class Hitch < ActiveRecord::Base
  ON_OFF_TYPE = 1
  DAYS_ON_TYPE = 2

	self.primary_key = 'hitch_id'

	has_many :calendars_hitches
	has_many :hitches, through: :calendars_hitches

	before_create do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  before_update do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  before_destroy do
  	# delete all calenders_hitch records
    CalendarsHitch.where(:hitch_id => self.id).destroy_all
  end

  def created_user_name
  	calendar_created_user = User.find(self.created_by)
  	calendar_created_user.first_name
  end

  def last_upated_user_name
  	calendar_created_user = User.find(self.last_updated_by)
  	calendar_created_user.first_name
  end

  def id
    hitch_id
  end

  def hitch_type
    if self.days_on
      Hitch::ON_OFF_TYPE
    else
      Hitch::DAYS_ON_TYPE
    end
  end

  def pick_working_dates(all_dates)
    if self.hitch_type == Hitch::ON_OFF_TYPE
      puts 'ON_OFF'
      pick_working_dates_with_on_off(all_dates)
    else
      pick_working_dates_with_days_on(all_dates)
    end
  end

   def pick_working_dates_with_on_off(all_dates)
    iter_work_days = 0
    iter_off_days = 0
    working_dates = []
    all_dates.each do |i|
      if iter_work_days < self.days_on
        iter_work_days += 1
        working_dates << i
      else
        if iter_off_days < self.days_off
          iter_off_days += 1
          next
        else
          iter_work_days = 1
          iter_off_days = 0

          working_dates << i
        end
      end
    end
    working_dates
  end

  def pick_working_dates_with_days_on(all_dates)
    working_days = get_working_days_array  # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
    working_dates = []

    puts '*'*87
    puts working_days
    puts '*'*96

    working_dates = all_dates.select {|k| working_days.include?(k.wday)}
  end

  def get_working_days_array
    working_days_array = []
    working_days_array << 0 if self.sun
    working_days_array << 1 if self.mon
    working_days_array << 2 if self.tue
    working_days_array << 3 if self.wed
    working_days_array << 4 if self.thu
    working_days_array << 5 if self.fri
    working_days_array << 6 if self.sat
    working_days_array
  end
end
