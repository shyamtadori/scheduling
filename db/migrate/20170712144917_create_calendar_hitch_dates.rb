class CreateCalendarHitchDates < ActiveRecord::Migration
  def change
    create_table :calendar_hitch_dates, id: false do |t|
    	t.primary_key :cal_date_hitch_id
      t.datetime :work_date
      t.integer :cal_hitch_id
    end
  end
end
