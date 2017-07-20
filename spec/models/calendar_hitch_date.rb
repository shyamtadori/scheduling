# spec/models/calendar_hitch_date_spec.rb
require 'rails_helper'

describe CalendarHitchDate do
	it do
		should belong_to(:calendars_hitch).
      with_foreign_key('cal_hitch_id')
  end
end