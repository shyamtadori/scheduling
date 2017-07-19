# spec/factories/calendars.rb
require 'faker'

FactoryGirl.define do
	factory :calendar do
		name 'Calendar Testing - 1'
		effective_start_date '2018-01-01'
		effective_end_date '2018-12-31'
	end

	trait :cal2017 do
		name 'Calendar 2017'
		effective_start_date '2017-01-01'
		effective_end_date '2017-12-31'
	end

	trait :cal2016 do
		name 'Calendar 2016'
		effective_start_date '2016-01-01'
		effective_end_date '2016-12-31'
	end
end

# FactoryGirl.define do
# 	factory :calendar do
# 		name { Faker::Calendar.name}
# 		effective_start_date { Faker::Calendar.effective_start_date }
# 		effective_end_date { Faker::Calendar.effective_end_date}
# 	end
# end
