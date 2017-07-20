# spec/factories/calendars.rb
require 'faker'

FactoryGirl.define do
	factory :calendars_hitch do
	end

	trait :with_no_initial_days do
	end

	trait :with_initial_days_on_7 do
		initial_days_on 7
	end

	trait :with_initial_days_off_7 do
		initial_days_off 7
	end

	trait :with_initial_days_on_7_and_initial_days_off_7 do
		initial_days_on 7
		initial_days_off 7
	end
end
