class CreateCalendarsHolidays < ActiveRecord::Migration
  def change
    create_table :calendars_holidays, id: false do |t|
      t.primary_key :cal_holiday_id
      t.integer :calendar_id
      t.integer :holiday_id
      t.integer :created_by
      t.integer :last_updated_by
      t.datetime :creation_date
      t.datetime :last_update_date
    end
  end
end
