class Calendar < ActiveRecord::Base
	self.primary_key = 'calendar_id'
  include CreatorModifier

	has_many :calendars_hitches
	has_many :hitches, through: :calendars_hitches

  has_many :calendars_holidays
  has_many :holidays, through: :calendars_holidays

  validates_presence_of :name, :effective_start_date, :effective_end_date
  validates_length_of :name, :maximum => 250
  validate :end_date_is_after_start_date

	before_create do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  before_update do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  before_destroy do
  	# delete all calender hitch records
    CalendarsHitch.where(:calendar_id => self.id).destroy_all
  end

  accepts_nested_attributes_for :calendars_holidays, :allow_destroy => true, :reject_if => proc { |obj| obj['calendar_id'].blank? or obj['holiday_id'].blank?}
  accepts_nested_attributes_for :holidays, :allow_destroy => true, :reject_if => proc { |obj| obj['name'].blank? or obj['description'].blank? or obj['holiday_date'].blank?}

  def id
    calendar_id
  end

  private
  def end_date_is_after_start_date
    return if effective_end_date.blank? || effective_start_date.blank?

    if effective_end_date <= effective_start_date
      errors.add(:effective_end_date, "cannot be before the start date") 
    end 
  end
end
