class ChangePilotsHitchEmployeeIdColumn < ActiveRecord::Migration
  def change
  	remove_column :pilots_hitches, :employee_id
  	add_column :pilots_hitches, :user_id, :integer
  	add_index :pilots_hitches, [:user_id, :hitch_id]
  end
end
