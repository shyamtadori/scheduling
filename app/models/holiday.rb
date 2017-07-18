class Holiday < ActiveRecord::Base
	self.primary_key = 'holiday_id'
  include CreatorModifier

  scope :time_between, ->(start_date, end_date) { where("holiday_date >= ? and holiday_date <= ?", start_date, end_date)}

	has_many :calendars_holidays
  has_many :calendars, through: :calendars_holidays

  validates_presence_of :name, :description, :holiday_date
  validates_length_of :name, :maximum => 250
  validates_length_of :description, :maximum => 1000

  before_create do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  before_update do
    self.last_updated_by = User.current.id
  end
end
