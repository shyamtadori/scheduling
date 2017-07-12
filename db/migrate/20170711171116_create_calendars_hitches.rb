class CreateCalendarsHitches < ActiveRecord::Migration
  def change
    create_table :calendars_hitches, id: false do |t|
      t.primary_key :cal_hitch_id
      t.integer :calendar_id
      t.integer :hitch_id
      t.integer :initial_days_on, :limit => 2
      t.integer :initial_days_off, :limit => 2
      t.integer :created_by
      t.integer :last_updated_by
      t.datetime :creation_date
      t.datetime :last_update_date
    end
  end
end
