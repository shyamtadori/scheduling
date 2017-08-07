class Schedule < ActiveRecord::Base
  self.primary_key = "schedule_id"
  belongs_to :job, class_name: 'Job', foreign_key: 'job_idx'
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  validates_uniqueness_of :schedule_date, :scope => [:job_idx, :assignment], :if => :not_AMT?

  # enum assignment: %w(PIC SIC)
  PIC = "PIC"
  SIC = "SIC"

	scope :monthly_schedule, lambda{|start_date, end_date, location_ids| where('location_idx in (?) and schedule_date >= ? and schedule_date <= ? and user_id is not null', location_ids, start_date, end_date)}

  def not_AMT?
    assignment != "AMT"
  end

	def self.allotted_pilots(start_date, end_date, location_ids)
		selected_month_schedules = Schedule.monthly_schedule(start_date, end_date, location_ids).includes(:user)
		allotted_pilots_hash = {}
    selected_month_schedules.each do |schedule|
      iter_date = schedule.schedule_date.day
      hash_key = "#{iter_date}_#{schedule.job_idx}"
      user_name = (schedule.user.username.gsub('_',' ') if schedule.user) || "Deleted User"
      value_of_element = "#{schedule.user.username.upcase}_#{schedule.user_id}"
      if allotted_pilots_hash[hash_key]
        if schedule.assignment == Schedule::PIC
          if allotted_pilots_hash[hash_key]["PIC"]
            allotted_pilots_hash[hash_key]["PIC"] += [value_of_element]
          else
            allotted_pilots_hash[hash_key]["PIC"] = [value_of_element]
          end
        elsif schedule.assignment == Schedule::SIC
          if allotted_pilots_hash[hash_key]["SIC"]
            allotted_pilots_hash[hash_key]["SIC"] += [value_of_element]
          else
            allotted_pilots_hash[hash_key]["SIC"] = [value_of_element]
          end
        end
      else
        allotted_pilots_hash[hash_key] = {}
        if schedule.assignment == Schedule::PIC
          allotted_pilots_hash[hash_key]["PIC"] = [value_of_element]
        elsif schedule.assignment == Schedule::SIC
          allotted_pilots_hash[hash_key]["SIC"] = [value_of_element]
        end
      end
    end
    return allotted_pilots_hash
	end

  def self.create_schedules(start_date, end_date, job, schedule_params, schedule_on_hitch, schedule_on_free, organization)
    user_id = schedule_params[:user_id]
    assignment_type = schedule_params[:assignment]
    pilot = User.find(user_id)
    available_dates = pilot.get_pilot_available_dates(start_date, end_date, schedule_on_hitch, schedule_on_free, organization)
    available_dates.each do |available_date|
      Schedule.create(schedule_date: available_date, job_idx: job.id, user_id: user_id, 
                      location_idx: job.location_idx, assignment: assignment_type)
    end
    return nil
  end
end
