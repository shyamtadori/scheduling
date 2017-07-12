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

  def created_user_name
  	calendar_hitch_created_user = User.find(self.created_by)
  	calendar_hitch_created_user.first_name
  end

  def last_upated_user_name
  	calendar_hitch_created_user = User.find(self.last_updated_by)
  	calendar_hitch_created_user.first_name
  end

  def id
    calendar_id
  end
end
