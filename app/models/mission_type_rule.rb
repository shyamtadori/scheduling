class MissionTypeRule < ActiveRecord::Base
	include CreatorModifier
  belongs_to :mission_type
  belongs_to :rule

  before_create do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  before_update do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end
  
  def id
  	mission_type_rule_id
  end
end
