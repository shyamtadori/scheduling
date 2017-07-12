class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars, id: false   do |t|
      t.primary_key :calendar_id
      t.string :name
      t.datetime :effective_start_date
      t.datetime :effective_end_date
      t.integer :created_by
      t.integer :last_updated_by
      t.datetime :creation_date
      t.datetime :last_update_date
    end
  end
end
