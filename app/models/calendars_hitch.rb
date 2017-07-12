class CalendarsHitch < ActiveRecord::Base
	self.primary_key = 'cal_hitch_id'

	belongs_to :calendar
	belongs_to :hitch

	before_create do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  before_update do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  after_save do
    create_calendar_dates
  end

  def created_user_name
  	calendar_hitch_created_user = User.find(self.created_by)
  	calendar_hitch_created_user.first_name
  end

  def last_upated_user_name
  	calendar_hitch_created_user = User.find(self.last_updated_by)
  	calendar_hitch_created_user.first_name
  end

  def id
    cal_hitch_id
  end

  private
  def create_calendar_dates
    start_date = calendar.effective_start_date.to_datetime
    end_date = calendar.effective_end_date.to_datetime

    hour_start = hitch.hour_start
    hour_end = hitch.hour_end

    all_dates_between = (start_date..end_date).to_a

    working_dates = hitch.pick_working_dates(all_dates_between)
    working_dates.each do |working_day|
      puts working_day
      CalendarHitchDate.new(:work_date => working_day, :cal_hitch_id => self.id).save
    end
  end
end
