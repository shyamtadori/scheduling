class AddIndexesToCalenedersHitchesAndCalendarHitchDates < ActiveRecord::Migration
  def change
  	add_index :calendars_hitches, [:calendar_id, :hitch_id]
  	add_index :calendars_hitches, :hitch_id
  	add_index :calendar_hitch_dates, :cal_hitch_id
  end
end
