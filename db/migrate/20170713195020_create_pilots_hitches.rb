class CreatePilotsHitches < ActiveRecord::Migration
  def change
    create_table :pilots_hitches, id: false do |t|
      t.primary_key :pilots_hitch_id
      t.integer :hitch_id
      t.integer :employee_id
      t.datetime :effective_start_date
      t.datetime :effective_end_date
      t.integer :created_by
      t.integer :last_updated_by
      t.datetime :creation_date
      t.datetime :last_update_date
    end
    add_index :pilots_hitches, [:employee_id, :hitch_id]
    add_index :pilots_hitches, :hitch_id
  end
end
