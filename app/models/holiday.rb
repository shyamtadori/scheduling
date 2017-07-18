class Holiday < ActiveRecord::Base
	self.primary_key = 'holiday_id'
  include CreatorModifier

	has_many :calendars_holidays
  has_many :calendars, through: :calendars_holidays

  before_create do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  before_update do
    self.last_updated_by = User.current.id
  end
end
