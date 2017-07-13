class Hitch < ActiveRecord::Base
	self.primary_key = 'hitch_id'

	has_many :calendars_hitches
	has_many :hitches, through: :calendars_hitches
  has_many :pilots_hitches

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


  def work_type
    if mon or tue or wed or thu or fri or sat or sun
      "week_days"
    else
      "days_on_off"
    end
  end
end
