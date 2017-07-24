class PilotsHitch < ActiveRecord::Base
	self.primary_key = 'pilots_hitch_id'
	include CreatorModifier
	
	belongs_to :hitch
	belongs_to :pilot, class_name: "User", foreign_key: "user_id"

	validates_presence_of :hitch
	validates_presence_of :pilot

	# validates_presence_of :effective_start_date, :effective_end_date
  # validate :end_date_is_after_start_date

  before_create do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  before_update do
    self.last_updated_by = User.current.id
  end

  def new_hitch_id
    
  end
  
  private
  def end_date_is_after_start_date
    return if effective_end_date.blank? || effective_start_date.blank?

    if effective_end_date <= effective_start_date
      errors.add(:effective_end_date, "cannot be before the start date") 
    end 
  end
end
