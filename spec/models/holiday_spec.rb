# spec/models/calendar_spec.rb
require 'rails_helper'

describe Holiday do
	User.current = User.find(1246)
	
	it "has a valid factory" do
		expect(create(:holiday, :holiday)).to be_valid
	end

	it "is invalid without a name" do
		expect(build(:calendar, name: nil)).to_not be_valid
	end
end