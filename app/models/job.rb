class Job < ActiveRecord::Base
	self.table_name = 'tbms_ch_job'
	self.primary_key = 'job_idx' 
  self.sequence_name = 'seq_tbms_jobs_pk'
  
	#attr_accessible :parent_idx, :contract_idx, :division_idx, :location_idx, :mobilization_location_idx
	#attr_accessible :demobilization_location_idx, :ac_model_idx, :current_log_idx, :document_name, :document_number, :subcharter_flag
	#attr_accessible :job_status, :billable_type, :service_type, :effective_start_date, :effective_end_date, :expected_term
	#attr_accessible :minimum_term, :memo, :job_name, :day_start_time, :day_stop_time, :sun, :mon, :tue, :wed, :thu, :fri, :sat
	#attr_accessible :shift_type, :num_of_ac


	belongs_to :contract, class_name: 'Contract', foreign_key: 'contract_idx'
	belongs_to :location, class_name: 'Location', foreign_key: 'location_idx'
	belongs_to :aircraft_model, class_name: 'AircraftModel', foreign_key: 'ac_model_idx'
	has_many :contract_rates, class_name: 'ContractRate', foreign_key: 'job_idx'

	validate :validation_tour

	def id
		job_idx.to_i
	end

	def name
		job_name		
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

		if valid_dates 
			customer = self.contract.customer
			if customer.jobs.where("job_idx != ? and upper(job_name) = upper(?) and (tbms_ch_job.effective_start_date between ? and ? or ? between tbms_ch_job.effective_start_date and tbms_ch_job.effective_end_date)", job_idx || 0, job_name, effective_start_date, effective_end_date, effective_start_date).present?
				errors.add(:effective_end_date, :conflicting_jobs, message: "Please check your Dates- They overlap with an existing job with the same job name")

			end
		end
	end
end