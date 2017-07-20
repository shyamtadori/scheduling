class CreateMissionTypeRules < ActiveRecord::Migration
  def change
    create_table :mission_type_rules, id: false do |t|
      t.primary_key :mission_type_rule_id
      t.integer :mission_type_id
      t.integer :rule_id
      t.datetime :effective_start_date
      t.datetime :effective_end_date
      
      t.integer :created_by
      t.integer :last_updated_by
      t.datetime :creation_date
      t.datetime :last_update_date
    end

    add_index :mission_type_rules, [:mission_type_id, :rule_id]
    add_index :mission_type_rules, :rule_id
  end
end
