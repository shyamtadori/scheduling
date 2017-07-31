# spec/factories/calendars.rb
require 'faker'

FactoryGirl.define do
	factory :holiday do
		name 'Holiday - 1'
		description 'Holiday on january 1 2018'
		holiday_date '2018-01-01'
	end
end
