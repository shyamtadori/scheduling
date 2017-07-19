class CalendarsHitch < ActiveRecord::Base
  self.primary_key = 'cal_hitch_id'
  include CreatorModifier
  
  belongs_to :calendar
  belongs_to :hitch
  has_many :calendar_hitch_dates, class_name: 'CalendarHitchDate', foreign_key: 'cal_hitch_id'

  validates_presence_of :hitch
  validates_presence_of :calendar
  validates_absence_of :initial_days_off, :message => ' & initial_days_on can not allowed together', :if => lambda { self.initial_days_on && self.initial_days_on > 0 }
  validates_absence_of :initial_days_on, :message => ' & initial_days_off can not allowed together', :if => lambda { self.initial_days_off && self.initial_days_off > 0 }
  validates_uniqueness_of :calendar_id, :scope => :hitch_id

  before_create do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  before_save do
    if hitch.hitch_type == Hitch::DAYS_ON_TYPE
      self.initial_days_on = 0
      self.initial_days_off = 0
    end
  end

  before_update do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  after_save do
    puts '&'*90
    puts "in calendar_hitch after_save:::::"
    create_calendar_dates
  end

  before_destroy do
    # delete all calendar_hitch_dates
    CalendarHitchDate.where(:cal_hitch_id => self.id).destroy_all
  end

  def id
    cal_hitch_id
  end

  private
  def create_calendar_dates
    start_date = calendar.effective_start_date.to_datetime
    end_date = calendar.effective_end_date.to_datetime

    all_dates_between = (start_date..end_date).to_a

    existing_working_dates = self.calendar_hitch_dates.pluck(:work_date)
    new_working_dates = []

    puts '='*90
    puts "existing_working_dates::::"
    puts existing_working_dates
    puts '='*90

    working_dates = hitch.pick_working_dates(all_dates_between, self.initial_days_on, self.initial_days_off)
    working_dates.each do |working_day|
      new_working_dates << ActiveSupport::TimeZone['UTC'].parse(working_day.strftime("%Y-%m-%d 00:00:00"))
      CalendarHitchDate.where(:work_date => working_day.strftime("%Y-%m-%d 00:00:00"), :cal_hitch_id => self.id).first_or_create
    end

    puts '+'*88
    puts 'new_working_dates:::'
    puts new_working_dates
    puts '+'*89

    puts '@'*80
    puts 'deleted_working_dates:::::'
    deleted_working_dates = existing_working_dates - new_working_dates
    CalendarHitchDate.where("cal_hitch_id = ? and work_date in (?)", self.id, deleted_working_dates).destroy_all if deleted_working_dates.length > 0
    puts '@'*88
  end

  def initial_offset_type
    if initial_days_on.present? and initial_days_on > 0
      "on"
    elsif initial_days_off.present? and initial_days_off > 0
      "off" 
    else
      nil
    end
  end
end
