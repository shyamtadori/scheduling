class PilotsHitch < ActiveRecord::Base
	belongs_to :hitch
	belongs_to :pilot, class_name: "User", foreign_key: "employee_id"

	validates_presence_of :hitch
	validates_presence_of :pilot

	validates_presence_of :effective_start_date, :effective_end_date
  validate :end_date_is_after_start_date

  before_create do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  before_update do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  def created_user_name
  	calendar_created_user = User.find(self.created_by)
  	calendar_created_user.first_name
  end

  def last_upated_user_name
  	calendar_created_user = User.find(self.last_updated_by)
  	calendar_created_user.first_name
  end

  private
  def end_date_is_after_start_date
    return if effective_end_date.blank? || effective_start_date.blank?

    if effective_end_date <= effective_start_date
      errors.add(:effective_end_date, "cannot be before the start date") 
    end 
  end
end
