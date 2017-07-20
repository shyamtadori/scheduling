class CreateMissionTypes < ActiveRecord::Migration
  def change
    create_table :mission_types, id: false do |t|
      t.primary_key :mission_type_id
      t.string :name
      t.string :description
      t.datetime :effective_start_date
      t.datetime :effective_end_date

      t.integer :created_by
      t.integer :last_updated_by
      t.datetime :creation_date
      t.datetime :last_update_date
    end
  end
end
