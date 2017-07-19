# spec/factories/calendars.rb
require 'faker'

FactoryGirl.define do
	factory :hitch do # default values
		name 'Hitch A'
		hour_start '08:30'
		hour_end '17:00'
	end

	trait :weekdays_hitch do
		name 'Hitch Weekdays'
		mon true
		tue true
		wed true
		thu true
		fri true
		sat false
		sun false
	end

	trait :seven_days_hitch do
		name 'Hitch 7/7'
		days_on 7
		days_off 7
	end

	trait :fourteen_days_hitch do
		name 'Hitch 14/14'
		days_on 14
		days_off 14
	end
end
