class Schedule < ActiveRecord::Base
  self.primary_key = "schedule_id"
  belongs_to :job, class_name: 'Job', foreign_key: 'job_idx'
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'

	scope :monthly_schedule, lambda{|start_date, end_date| where('schedule_date >= ? and schedule_date <= ?', start_date, end_date)}

	def self.allotted_pilots(start_date, end_date)
		selected_month_schedules = Schedule.monthly_schedule(start_date, end_date).includes(:user)
		allotted_pilots_hash = {}
    selected_month_schedules.each do |schedule|
      iter_date = schedule.schedule_date.day
      hash_key = "#{iter_date}_#{schedule.job_idx}"
      if allotted_pilots_hash[hash_key]
        allotted_pilots_hash[hash_key] += [schedule.user.username]
      else
        allotted_pilots_hash[hash_key] = [schedule.user.username]
      end
    end
    return allotted_pilots_hash
	end

  def self.create_schedules(start_date, end_date, job, user_id, schedule_on_hitch, schedule_on_free, organization)
    pilot = User.find(user_id)
    available_dates = pilot.get_pilot_available_dates(start_date, end_date, schedule_on_hitch, schedule_on_free, organization)
    available_dates.each do |available_date|
      Schedule.create(schedule_date: available_date, job_idx: job.id, user_id: user_id)
    end
    return nil
  end
end
