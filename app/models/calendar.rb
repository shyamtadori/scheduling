class Calendar < ActiveRecord::Base
	self.primary_key = 'calendar_id'
  include CreatorModifier

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
  	# delete all calender hitch records
    CalendarsHitch.where(:calendar_id => self.id).destroy_all
  end

  def id
    calendar_id
  end
end
