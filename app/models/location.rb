class Location < ActiveRecord::Base
	self.table_name = 'sg_locations'
	self.primary_key = 'location_idx'
	self.sequence_name = 'seq_sg_locations'

	#attr_accessible :location_idx, :location_type_idx, :location_name, :lat, :lon, :fuel_available_flag, :maximum_allowable_weight
  #attr_accessible :landing_area, :locationinformation, :location_radio_info, :last_update_date, :status, :phone, :company, :rig_name
	#attr_accessible :parish_county, :state, :isfederallyfundedairport, :description, :radiorange150, :radiorange500, :radiostatus
	#attr_accessible :radiofrequency, :strippedlocation, :large_ac_capable_flag, :fuel_comments, :important_info, :era_base, :last_updated_by
	#attr_accessible :creation_date, :created_by, :shape, :location_long_name, :loc_time_zone, :wifi, :ssid, :uid_pwd, :fuel_owner
	#attr_accessible :last_inspection_date, :deck_value, :complex_id_num, :helideck_max_weight, :helideck_length, :helideck_width
	#attr_accessible :fuel_status, :fuel_remarks, :fuel_phone, :fuel_phone_2, :fuel_radio, :fuel_radio_2, :base_radio, :grd_radio, :company_radio, :marine_radio
	#attr_accessible :company_phone, :bsee_title, :helideck_shape_idx

	has_many :jobs, class_name: 'Job', foreign_key: :location_idx
	scope :bases, -> { where('"SG_LOCATIONS"."LOCATION_TYPE_IDX" IN (5,6)')}

	def id
		location_idx.to_i
	end

	def bsee_match
		sql = "SELECT B.COMPLEX_ID_NUMBER,
									B.TITLE,
									B.COMPANY,
									B.AREA_NAME,
									B.DESIGNATION,
									B.STRUCTURE_DESCRIPTION,
									B.DISTRICT_NAME,
									B.BLOCK_NUMBER,
									B.GPS_LAT,
									B.GPS_LON,
									B.GPS_GEOM,
									UTL_MATCH.jaro_winkler_similarity(b.title, '#{self.location_name}') simularity_rating
					 FROM SEAGAN.BSEE_PLATFORMS B 
					 WHERE B.TITLE LIKE '#{self.location_name[0...2]}%' ORDER BY SIMULARITY_RATING DESC"
		results = ActiveRecord::Base.connection.exec_query(sql)

		if results.rows.count > 25
			sql = "SELECT B.COMPLEX_ID_NUMBER,
									B.TITLE,
									B.COMPANY,
									B.AREA_NAME,
									B.DESIGNATION,
									B.STRUCTURE_DESCRIPTION,
									B.DISTRICT_NAME,
									B.BLOCK_NUMBER,
									B.GPS_LAT,
									B.GPS_LON,
									B.GPS_GEOM,
									UTL_MATCH.jaro_winkler(b.title, '#{self.location_name}') simularity_rating
					 FROM SEAGAN.BSEE_PLATFORMS B 
					 WHERE UTL_MATCH.jaro_winkler(b.title, '#{self.location_name}') > 0.75 ORDER BY SIMULARITY_RATING DESC"
			results = ActiveRecord::Base.connection.exec_query(sql)
		end
	 	return results
	end

	def self.export_fuel_sites
		sql = "SELECT a.location_name,
									a.helideck_max_weight, 
									a.helideck_length, 
									a.helideck_width,
									lu.lookup_code helideck_shape,
									a.fuel_status,
									a.lat,
									a.lon,
									a.fuel_phone,
									a.fuel_phone_2,
									a.phone,
									a.company_phone, 
									a.fuel_owner,  
									a.fuel_radio,
									a.fuel_radio_2,
									a.base_radio, 
									a.grd_radio, 
									a.company_radio, 
									a.marine_radio,
									a.location_radio_info,
									a.rig_name,
									a.fuel_remarks,
									a.fuel_comments,
									a.last_inspection_date, 
									a.locationinformation, 
									a.company, 
									a.parish_county, 
									a.state, 
									a.description, 
									a.radiorange150, 
									a.radiorange500, 
									a.radiostatus,
									a.radiofrequency,  
									a.important_info, 
									a.era_base, 
									a.location_long_name,
									a.loc_time_zone, 
									a.wifi, 
									a.ssid, 
									a.uid_pwd    
					FROM seagan.sg_locations a left outer join seagan.sg_lookups lu on lu.lookups_idx = a.helideck_shape_idx where a.fuel_available_flag = 'Y' and status = 'A'"
		results = ActiveRecord::Base.connection.exec_query(sql)
		return results		
	end

	def self.location_with_type
		sql = "SELECT u.lookup_code, l.* FROM SEAGAN.SG_LOCATIONS l inner join seagan.sg_lookups u on u.lookups_idx = l.location_type_idx and u.lookup_type = 'LOCATION_TYPE' where l.status = 'A' and u.lookups_idx != 9 order by u.lookup_code, l.location_name"
		results = ActiveRecord::Base.connection.exec_query(sql)
		return results
	end

	def lat_lon
		if lat.present? and lon.present?
			"%.5f" % self[:lat] + "/%.5f" % self[:lon] 
		else
			nil
		end
	end

	def location_type
		Lookup.select('LOOKUP_CODE').where("lookups_idx = ? and u.lookup_type = 'LOCATION_TYPE' where l.status = 'A'", self.location_type_idx).first
	end

end

