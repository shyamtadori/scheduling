class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays, id: false do |t|
      t.primary_key :holiday_id
      t.string :name
      t.text :description
      t.date :holiday_date
      t.integer :created_by
      t.datetime :creation_date
      t.integer :last_updated_by
      t.datetime :last_update_date
    end
  end
end
