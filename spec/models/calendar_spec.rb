# spec/models/calendar_spec.rb
require 'rails_helper'

describe Calendar do
	# let(:user) { User.find(1246) }
	User.current = User.find(1246)
	
	it "has a valid factory" do
		# expect(build(:calendar)).to be_valid
		expect(create(:calendar, :cal2016)).to be_valid
	end

	it "is invalid without a name" do
		expect(build(:calendar, name: nil)).to_not be_valid
	end

	it "is invalid without effective_start_date" do
		expect(build(:calendar, effective_start_date: nil)).to_not be_valid
	end

	it "is invalid without effective_end_date" do
		expect(build(:calendar, effective_end_date: nil)).to_not be_valid
	end

	it "is invalid if start_date is after end_date" do
		expect(build(:calendar, effective_start_date: '2017-12-31', effective_end_date: '2017-01-01')).to_not be_valid
	end
end