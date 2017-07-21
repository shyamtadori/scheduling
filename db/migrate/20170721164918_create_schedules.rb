class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules, id: false do |t|
      t.primary_key :schedule_id
      t.datetime :schedule_date 
      t.integer :location_idx 
      t.integer :job_idx 
      t.integer :model_idx 
      t.integer :mission_id 
      t.integer :asset_idx 
      t.integer :pic_id 
      t.integer :sic_id 
      t.integer :user_id
      t.string  :status
      t.string :assignment
    end
  end
end