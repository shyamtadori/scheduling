class Customer < ActiveRecord::Base
	self.table_name = 'sg_customers'
	self.primary_key = 'customer_idx' 
	#attr_accessible :customer_name, :processed_flag, :address, :city
	#attr_accessible :state, :country, :alt_customer_name, :ar_site_number

	has_many :contracts, class_name: 'Contract', foreign_key: 'customer_idx'
	has_many :jobs, through: :contracts
	
	def id
		customer_idx.to_i
	end

	def self.active
		Customer.where('"'+Customer.table_name.upcase+'"."PROCESSED_FLAG" != ' + "'R'").order(:customer_name)
	end

	def customer_idx
		self['customer_idx'].to_i
	end
end