class Contract < ActiveRecord::Base
	self.table_name = 'tbms_contracts'
	self.primary_key = 'contract_idx' 
  self.sequence_name = 'seq_tbms_contracts'

	#attr_accessible :customer_idx, :organization_unit_idx, :default_currency_id
	#attr_accessible :split_currency_id, :attention, :bid_reference, :client_reference
	#attr_accessible :contract_descr, :contract_reference, :contact_person, :contract_status
	#attr_accessible :split_type, :last_billed_date, :effective_start_date, :effective_end_date
	#attr_accessible :period_days, :period_months, :period_years, :period_length, :contract_memo
	#attr_accessible :billing_memo

	belongs_to :customer, class_name: 'Customer', foreign_key: 'customer_idx'
	has_many :jobs, class_name: 'Job', foreign_key: 'contract_idx'
	has_many :contract_rates, class_name: 'ContractRate', foreign_key: 'contract_idx'

	validate :validation_tour

	def id
		contract_idx.to_i
	end

	def name
		contract_reference
	end

	def validation_tour
		valid_dates = true
		if effective_start_date.nil?
			errors.add(:effective_start_date,:blank, message: 'Not a valid date')
			valid_dates = false
		end
		if effective_end_date.nil?
			errors.add(:effective_end_date,:blank, message: 'Not a valid date')
			valid_dates = false
		end
		if valid_dates and effective_start_date > effective_end_date
			errors.add(:effective_end_date, :end_date_after_start_date, message: 'Needs to be after Start Date')
			valid_dates = false
		end

		if valid_dates and Contract.where("contract_idx != ? and upper(contract_reference) = upper(?) and customer_idx = ? ", contract_idx || 0, contract_reference, customer_idx).present?
			errors.add(:contract_reference, :conflicting_contract, message: "There is already a contract for this customer with the same contract reference")
		end
	end
end