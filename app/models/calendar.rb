class Calendar < ActiveRecord::Base
	self.primary_key = 'calendar_id'

	has_many :calendars_hitches#, dependent: :destroy
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
  	 # puts "*"*90
    # puts self.id
    # puts self.calendar_id
    puts CalendarsHitch.where(:calendar_id => self.id).length
    CalendarsHitch.where('"CALENDARS_HITCHES"."CALENDAR_ID" = ?',self.id).destroy_all
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
    calendar_id
  end
end
