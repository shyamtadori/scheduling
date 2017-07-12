class CreateHitches < ActiveRecord::Migration
  def change
    create_table :hitches, id: false  do |t|
      t.primary_key :hitch_id
      t.string :name
      t.integer :days_on, :limit => 2
      t.integer :days_off, :limit => 2
      t.boolean :mon
      t.boolean :tue
      t.boolean :wed
      t.boolean :thu
      t.boolean :fri
      t.boolean :sat
      t.boolean :sun
      t.datetime :hour_start
      t.datetime :hour_end
      t.integer :created_by
      t.integer :last_updated_by
      t.datetime :creation_date
      t.datetime :last_update_date
    end
  end
end
