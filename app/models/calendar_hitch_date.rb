class CalendarHitchDate < ActiveRecord::Base
	belongs_to :calendars_hitch, class_name: 'CalendarsHitch', foreign_key: 'cal_hitch_id'
end
