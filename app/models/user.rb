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
  has_many :calendar_hitch_dates, through: :calendars_hitches
  
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

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
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