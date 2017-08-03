class AircraftModel < ActiveRecord::Base
	self.table_name = 'aircraft_models'
  self.primary_key = 'ac_model_idx'
  #attr_accessor :aircraft_users_attributes, :aircraft_models, :created_by

  has_many :jobs, class_name: 'Job', foreign_key: 'ac_model_idx' 

  def self.type_models
    select('Distinct("SEAGAN"."HL_AIRCRAFT_MODELS"."DEFAULT_MODEL") model_name').map(&:model_name).compact
  end

  def self.models
  	select("Distinct(model_name) as model_name").pluck(:model_name)
  end

  def readonly?
		true
	end
end