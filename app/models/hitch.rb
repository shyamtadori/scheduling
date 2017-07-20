class Hitch < ActiveRecord::Base
  ON_OFF_TYPE = 1
  DAYS_ON_TYPE = 2

	self.primary_key = 'hitch_id'
  include CreatorModifier

	has_many :calendars_hitches
  has_many :pilots_hitches
  has_many :pilots, through: :pilots_hitches

  accepts_nested_attributes_for :pilots_hitches

  validates_presence_of :name, :hour_start, :hour_end
  validates_length_of :name, :maximum => 250
  validate :hour_end_is_after_hour_start
  validate :hitch_type_should_not_be_null
  validates_presence_of :days_on, :if => lambda { self.days_off && self.days_off > 0 }
  validates_presence_of :days_off, :if => lambda { self.days_on && self.days_on > 0 }
  validates_numericality_of :days_on, :only_integer => true, :greater_than => 0, :if => lambda { self.days_on && self.days_on == 0 }
  validates_numericality_of :days_off, :only_integer => true, :greater_than => 0, :if => lambda { self.days_off && self.days_off == 0 }

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

  def id
    hitch_id
  end

  def work_type
    if mon or tue or wed or thu or fri or sat or sun
      "week_days"
    else
      "days_on_off"
    end
  end

  def hitch_type
    if self.days_on
      Hitch::ON_OFF_TYPE
    else
      Hitch::DAYS_ON_TYPE
    end
  end

  def pick_working_dates(all_dates, initial_days_on, initial_days_off)
    if self.hitch_type == Hitch::ON_OFF_TYPE
      pick_working_dates_with_on_off(all_dates, initial_days_on, initial_days_off)
    else
      pick_working_dates_with_days_on(all_dates)
    end
  end

   def pick_working_dates_with_on_off(all_dates, initial_days_on, initial_days_off)
    iter_work_days = 0
    iter_off_days = 0
    working_dates = []

    ######## Handling initial_days_off and initial_days_on #################
    all_dates.shift(initial_days_off) if initial_days_off
    if initial_days_on
      working_dates = working_dates + all_dates.shift(initial_days_on)
      all_dates.shift(self.days_off)
    end
    #########################################################################

    # Iterating the dates and adding work dates to working_dates
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

    working_dates = all_dates.select {|k| working_days.include?(k.wday)}
    working_dates
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

  private
  def hour_end_is_after_hour_start
    return if hour_end.blank? || hour_start.blank?

    if hour_end <= hour_start
      errors.add(:hour_end, "cannot be before the hour start")
    end
  end

  def hitch_type_should_not_be_null
    return if days_on || days_off
    errors.add(:hitch, "choose hitch type")  if !mon && !tue && !wed && !thu && !fri && !sat
  end
end
