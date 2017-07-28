class Schedule < ActiveRecord::Base
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'

	scope :monthly_schedule, lambda{|start_date, end_date| where('schedule_date >= ? and schedule_date <= ?', start_date, end_date)}

	def self.allotted_pilots(start_date, end_date)
		selected_month_schedules = Schedule.monthly_schedule(start_date, end_date)
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
end
