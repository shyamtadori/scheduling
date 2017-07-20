# spec/models/calendars_hitch_spec.rb
require 'rails_helper'

describe CalendarsHitch do
	before do
		User.current = User.find(1246)
		@calendar = create(:calendar, :cal2016)
		@calendar_2017 = create(:calendar, :cal2017)
		@calendar_jan_2017 = create(:calendar, :cal_jan_2017)
		@hitch = create(:hitch, :weekdays_hitch)
		@seven_days_hitch = create(:hitch, :seven_days_hitch)
		@weekdays_hitch = create(:hitch, :weekdays_hitch)
		@calendar.hitches << @hitch
	end
	
	it 'calender should have a hitch' do
		expect(@calendar.hitches.length).to eq(1)
	end

	it 'number of calendar dates of 2016 calendar with weekdays_hitch' do
		expect(@calendar.calendars_hitches[0].calendar_hitch_dates.length).to eq(261)
	end

	it 'number of calendar dates of 2017 calendar with seven_days_hitch' do
		@calendar_2017.hitches << @seven_days_hitch
		expect(@calendar_2017.calendars_hitches[0].calendar_hitch_dates.length).to eq(183)
	end

	it 'number of calendar dates of january 2017 calendar with seven_days_hitch and 3 initial days off' do
		create(:calendars_hitch, :with_initial_days_off_3, calendar_id: @calendar_jan_2017.id, hitch_id: @seven_days_hitch.id)
		expect(@calendar_jan_2017.calendars_hitches[0].calendar_hitch_dates.length).to eq(14)
	end

	it 'number of calendar dates of january 2017 calendar with seven_days_hitch and 3 initial days on' do
		create(:calendars_hitch, :with_initial_days_on_3, calendar_id: @calendar_jan_2017.id, hitch_id: @seven_days_hitch.id)
		expect(@calendar_jan_2017.calendars_hitches[0].calendar_hitch_dates.length).to eq(17)
	end

	it 'is invalid if both days on and days off choosen' do
		expect(build(:calendars_hitch, :with_initial_days_on_7_and_initial_days_off_7, calendar_id: @calendar.id, hitch_id: @seven_days_hitch.id )).to_not be_valid
	end

	it { should validate_uniqueness_of(:calendar_id).scoped_to(:hitch_id) }

	# it 'is invalid if days on or days off choosen for weekdays hitch' do
	# 	expect(build(:calendars_hitch, :with_initial_days_on_3, calendar_id: @calendar.id, hitch_id: @weekdays_hitch.id )).to_not be_valid
	# end
end