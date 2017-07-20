# spec/models/calendars_hitch_spec.rb
require 'rails_helper'

describe CalendarsHitch do
	before do
		User.current = User.find(1246)
		@calendar = create(:calendar, :cal2016)
		@hitch = create(:hitch, :weekdays_hitch)
		@weekdays_hitch = create(:hitch, :weekdays_hitch)
		@seven_days_hitch = create(:hitch, :seven_days_hitch)
		@calendar.hitches << @hitch
	end
	
	it 'calender should have a hitch' do
		expect(@calendar.hitches.length).to eq(1)
		puts '!'*100
		puts @calendar.calendars_hitches[0].calendar_hitch_dates.length
		expect(@calendar.calendars_hitches[0].calendar_hitch_dates.length).to eq(261)
	end

	it 'is invalid if both days on and days off choosen' do
		expect(build(:calendars_hitch, :with_initial_days_on_7_and_initial_days_off_7, calendar_id: @calendar.id, hitch_id: @seven_days_hitch.id )).to_not be_valid
	end

	it { should validate_uniqueness_of(:calendar_id).scoped_to(:hitch_id) }

	# it 'is invalid if days on or days off choosen for weekdays hitch' do
	# 	expect(build(:calendars_hitch, :with_initial_days_on_7, calendar_id: @calendar.id, hitch_id: @weekdays_hitch.id )).to_not be_valid
	# end
end