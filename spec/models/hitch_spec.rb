# spec/models/hitch_spec.rb
require 'rails_helper'

describe Hitch do
	# let(:user) { User.find(1246) }
	User.current = User.find(1246)

	it "has a valid week-days factory" do
		expect(build(:hitch, :weekdays_hitch)).to be_valid
	end

	it "has a valid seven-days factory" do
		expect(build(:hitch, :seven_days_hitch)).to be_valid
	end

	it "is invalid without a name" do
		expect(build(:hitch, :weekdays_hitch, name: nil)).to_not be_valid
	end

	it "is invalid without hour_start" do
		expect(build(:hitch, :seven_days_hitch, hour_start: nil)).to_not be_valid
	end

	it "is invalid without hour_end" do
		expect(build(:hitch, :seven_days_hitch, hour_end: nil)).to_not be_valid
	end

	it "is invalid if hour_end is before hour_start" do
		expect(build(:hitch, hour_start: '24:00', hour_end: '01:00')).to_not be_valid
	end

	it "is invalid if hitch type is not choosen" do
		expect(build(:hitch)).to_not be_valid
	end

	it "is invalid if days_on choosen and not days_off" do
		expect(build(:hitch, :seven_days_hitch, days_off: nil)).to_not be_valid
	end

	it "is invalid if days_off choosen and not days_on" do
		expect(build(:hitch, :seven_days_hitch, days_on: nil)).to_not be_valid
	end

	it "is invalid if days_off choosen and not days_on" do
		expect(build(:hitch, :seven_days_hitch, days_on: nil)).to_not be_valid
	end

	it "is invalid if days_off and days_on are 0 and mon-sun are nil" do
		expect(build(:hitch, days_on: 0, days_off: 0)).to_not be_valid
	end
end