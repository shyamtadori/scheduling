class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  self.table_name = 'era.trn_users'
  self.primary_key = "user_id"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable
  devise :timeoutable
  # Setup accessible (or protected) attributes for your model

  # :email, :end_date, :last_update_date, :last_updated_by
  # :username, :first_name, :job_description, :last_name, :status, :created_by
  # :hr_group, :organization, :updated_by, :in_avatier, :pilot, :amt

  PILOT_TYPE = 'pilot'
  AMT_TYPE = 'AMT'
  
  TIME_ZONE_OPTIONS = ActiveSupport::TimeZone::MAPPING.select{ |k , v| ["Central Time (US & Canada)","Alaska", "UTC", "Eastern Time (US & Canada)", "Pacific Time (US & Canada)", "Brasilia"].include?(k)  }.to_a.each{ |a| a.reverse!}
  
  has_many :pilots_hitches, class_name: "PilotsHitch", foreign_key: "user_id"
  has_many :hitches, through: :pilots_hitches
  has_many :calendars_hitches, through: :hitches
  has_many :calendars, through: :calendars_hitches
  has_many :calendars_holidays, through: :calendars
  has_many :holidays, through: :calendars_holidays
  has_many :calendar_hitch_dates, through: :calendars_hitches
  has_many :schedules
  
  scope :pilot, -> { where(pilot: true) }

  def timeout_in
    if Rails.env.development?
      return 1.year
    else
      return 15.minutes
    end
  end

  def readonly?
    false
  end

  def encrypted_password=(a)
    return true
  end

  def encrypted_password
    return false
  end

  def user_name
    username
  end

  def full_name
    (last_name || "") + ', ' + (first_name || "")
  end

  def type
    if pilot
      PILOT_TYPE
    elsif amt
      AMT_TYPE
    else
      "N/A"
    end
  end

  def id
    user_id.to_i
  end

  def employee_id
    self[:employee_id].to_i  
  end

  def days_hash_with_hitch_names(work_days)
    user_working_dates = calendar_hitch_dates.includes(:calendars_hitch => :hitch).order("work_date asc")

    days_hash = {}
    user_working_dates.each do |record|
      if work_days.include? record.work_date.to_date
        if days_hash[record.work_date.to_date]
          days_hash[record.work_date.to_date] += [record.calendars_hitch.hitch.name]
        else
          days_hash[record.work_date.to_date] = [record.calendars_hitch.hitch.name]
        end
      end
    end
    return days_hash
  end

  def days_hash_with_job_names(work_days)
    user_schedules = schedules.includes(:job)
    # user_schedules = user_schedules1.as_json(:only => [:schedule_id,:schedule_date,:job_idx],:include => {:job => {:only => [:job_idx,:job_name]}})
    days_hash = {}
    user_schedules.each do |record|
      if work_days.include? record.schedule_date.to_date
        if days_hash[record.schedule_date.to_date]
          days_hash[record.schedule_date.to_date] += [record.job.job_name]
        else
          days_hash[record.schedule_date.to_date] = [record.job.job_name]
        end
      end
    end
    return days_hash
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def self.get_pilots_available_on(schedule_date, organization)
    calendar_hitch_ids = CalendarHitchDate.where(work_date: schedule_date).pluck(:cal_hitch_id).map(&:to_s)
    org_calendar_ids = organization.calendar_ids
    hitch_ids = CalendarsHitch.where("cal_hitch_id in (?) and calendar_id in (?)", calendar_hitch_ids, org_calendar_ids).pluck(:hitch_id).map(&:to_s)

    all_available_pilot_ids = PilotsHitch.where('hitch_id in (?) and effective_start_date <= ? and (effective_end_date >= ? or effective_end_date is null)', hitch_ids, schedule_date, schedule_date).pluck(:user_id)
    pilot_ids_working_on_this_date = Schedule.where(schedule_date: schedule_date).pluck(:user_id)
    available_pilot_ids = all_available_pilot_ids - pilot_ids_working_on_this_date
    return User.where('user_id in (?)',available_pilot_ids)
  end

  def all_working_dates_of_pilot(organization)
    all_working_dates = []
    org_calendar_ids = organization.calendar_ids
    pilots_hitches.each do |pilot_hitch|
      cal_hitch_ids = CalendarsHitch.where("hitch_id = ? and calendar_id in (?)", pilot_hitch.hitch_id, org_calendar_ids).pluck(:cal_hitch_id)
      start_date = pilot_hitch.effective_start_date
      end_date = pilot_hitch.effective_end_date
      if end_date
        working_dates = CalendarHitchDate.where('CAL_HITCH_ID IN (?) AND WORK_DATE >= ? AND WORK_DATE <= ?',cal_hitch_ids, start_date, end_date).group('WORK_DATE').pluck(:WORK_DATE).map(&:to_date)
      else
        working_dates = CalendarHitchDate.where('CAL_HITCH_ID IN (?) AND WORK_DATE >= ?',cal_hitch_ids, start_date).group('WORK_DATE').pluck(:WORK_DATE).map(&:to_date)
      end
      all_working_dates += working_dates
    end
    return all_working_dates
  end

  def get_pilot_available_dates(start_date, end_date, schedule_on_hitch, schedule_on_free, organization)
    pilot_all_working_dates = self.all_working_dates_of_pilot(organization)
    if schedule_on_hitch
      pilot_working_dates_between = ((start_date..end_date).map(&:to_date)) & pilot_all_working_dates
    else
      pilot_working_dates_between = (start_date..end_date).map(&:to_date)
    end

    if schedule_on_free
      pilot_scheduled_dates = Schedule.where("schedule_date >= ? and schedule_date <= ? and user_id = ?", start_date, end_date, self.id).pluck(:schedule_date).map(&:to_date)
    else
      pilot_scheduled_dates = []
    end
    return (pilot_working_dates_between - pilot_scheduled_dates)
  end

  # def conflicting_dates
  #   calendar_hitch_ids = calendars_hitches.pluck(:cal_hitch_id).map(&:to_s)
  #   CalendarHitchDate.where("CAL_HITCH_ID IN (?)", calendar_hitch_ids)
  #                    .select("COUNT(calendar_hitch_dates.work_date), calendar_hitch_dates.work_date")
  #                    .having('count(*)>1').group(:work_date).pluck(:work_date).map(&:to_date)
  # end

  # def validate_hitch_assignment(new_hitch_ids)
  #   existing_calendar_hitch_ids = self.calendars_hitches.pluck(:cal_hitch_id).map(&:to_s)
  #   existing_work_dates = CalendarHitchDate.where('CAL_HITCH_ID IN (?)',existing_calendar_hitch_ids).group('WORK_DATE').pluck(:WORK_DATE)

  #   new_calendar_hitch_ids = CalendarsHitch.where("hitch_id in (?)",new_hitch_ids).pluck(:cal_hitch_id).map(&:to_s)
  #   conflicting_work_dates = CalendarHitchDate.where('CAL_HITCH_ID IN (?) AND WORK_DATE IN (?)', new_calendar_hitch_ids, existing_work_dates).pluck(:WORK_DATE)
  #   puts '&'*90
  #   puts conflicting_work_dates
  #   puts '&'*90
  #   errors.add(:hitches, "Conflict in working dates") if !conflicting_work_dates.empty?
  # end
end