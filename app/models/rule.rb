class Rule < ActiveRecord::Base
	include CreatorModifier

	has_many :mission_type_rules
	has_many :mission_types, through: :mission_type_rules

	before_create do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

  before_update do
    self.created_by = User.current.id
    self.last_updated_by = User.current.id
  end

	def id
		rule_id
	end
end
