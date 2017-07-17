class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules, id: false do |t|
      t.primary_key :rule_id
      t.string :name
      t.string :description
      t.string :code_block
      t.datetime :effective_start_date
      t.datetime :effective_end_date
      
      t.integer :created_by
      t.integer :last_updated_by
      t.datetime :creation_date
      t.datetime :last_update_date
    end
  end
end
