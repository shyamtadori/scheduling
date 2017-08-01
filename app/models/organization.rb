class Organization < ActiveRecord::Base

	self.table_name = 'sg_ramco_organizations'
  self.primary_key = 'org_unit'
  #attr_accessible  :org_unit, :company

  ERA_ORGANIZATION_UNIT = 2

  has_many :users, class_name: "User", foreign_key: "org_unit"
  has_many :calendars, class_name: "User", foreign_key: "org_unit"
  has_many :locations, class_name: "Location", foreign_key: "org_unit"
  has_many :bases, -> { bases }, class_name: "Location", foreign_key: "org_unit"

 
  # This is a SQL materialized view,
  # so there is no need to try to edit its records ever.
  # Doing otherwise, will result in an exception being thrown
  # by the database connection.
  def id
    org_unit.to_i
  end

  def readonly?
    true
  end
end
