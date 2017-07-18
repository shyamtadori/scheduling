class CalendarsHoliday < ActiveRecord::Base
	self.primary_key = 'cal_holiday_id'
  include CreatorModifier

	belongs_to :calendar
	belongs_to :holiday

	before_create do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  before_update do
    self.last_updated_by = User.current.id
  end
end
