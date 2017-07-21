
class Lookup < ActiveRecord::Base
	self.table_name = 'sg_lookups'
	self.primary_key = 'lookups_idx'

	#attr_accessible :lookup_type, :lookup_code, :meaning, :description, :enabled_flag, :start_date_active, :end_date_active
  #attr_accessible :created_by, :creation_date, :last_updated_by, :last_update_date, :business_unit_id, :lookups_idx
  #attr_accessible :field_type, :field_mask

	def id
		lookups_idx.to_i
	end
	
	def self.fuel_owners
		Lookup.find_by_lookup_type('FUEL_OWNER')
	end

	def self.find_by_lookup_type(lookup_type)
		Lookup.where("lookup_type = ? AND enabled_flag = 'Y' AND sysdate between start_date_active and end_date_active", lookup_type.upcase).order(:lookup_code)
	end
end