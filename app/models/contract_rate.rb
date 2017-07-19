class ContractRate < ActiveRecord::Base
	self.table_name = 'tbms_contract_rates'
	self.primary_key = 'rate_idx' 
	self.sequence_name = 'seq_tbms_contract_rates'

	#attr_accessible :contract_idx, :transaction_type_idx, :rate_type_idx
	#attr_accessible :rollup_type, :status_type, :start_date, :end_date, :base_rate
	#attr_accessible :sy_log_idx, :sy_log_nmbr, :job_idx, :ac_model_idx
	
	belongs_to :contract, class_name: 'Contract', foreign_key: 'contract_idx'
	belongs_to :job, class_name: 'Job', foreign_key: 'job_idx'

	validate :validation_tour

	def id
		rate_idx.to_i
	end

	def self.rate_types
		sql = "SELECT  lu.lookups_idx, lu.lookup_type transaction_type,
							     lu.meaning
							FROM seagan.tbms_sg_lookups lu
							order by lu.lookup_type, lu.meaning"
		results = ActiveRecord::Base.connection.exec_query(sql)
		return results
	end

	def validation_tour
		valid_dates = true
		if start_date.nil?
			errors.add(:start_date,:blank, message: 'Not a valid date')
			valid_dates = false
		end
		if end_date.nil?
			errors.add(:end_date,:blank, message: 'Not a valid date')
			valid_dates = false
		end
		if valid_dates and start_date > end_date
			errors.add(:end_date, :end_date_after_start_date, message: 'Needs to be after Start Date')
			valid_dates = false
		end
		byebug
		if valid_dates  
			if ContractRate.where("rate_idx != ? and rate_type_idx = ? and contract_idx = ? and (start_date between ? and ? or ? between start_date and end_date)", rate_idx || 0, rate_type_idx, contract_idx, start_date, end_date, start_date).present?
				errors.add(:end_date, :conflicting_contract, message: "Please check your Dates- They overlap with an existing Contract with the same contract reference")
			end
		end
	end
end