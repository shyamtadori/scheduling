class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  self.table_name = 'era.trn_users'
  self.primary_key = "user_id"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable
  devise :timeoutable, :timeout_in => 15.minutes
  # Setup accessible (or protected) attributes for your model

  # :email, :end_date, :last_update_date, :last_updated_by
  # :username, :first_name, :job_description, :last_name, :status, :created_by
  # :hr_group, :organization, :updated_by, :in_avatier, :pilot, :amt

  
  TIME_ZONE_OPTIONS = ActiveSupport::TimeZone::MAPPING.select{ |k , v| ["Central Time (US & Canada)","Alaska", "UTC", "Eastern Time (US & Canada)", "Pacific Time (US & Canada)", "Brasilia"].include?(k)  }.to_a.each{ |a| a.reverse!}
  
  def readonly?
    true
  end

  def encrypted_password=(a)
    return true
  end

  def encrypted_password
    return false
  end

  def user_name
    username
  end

  def full_name
    (last_name || "") + ', ' + (first_name || "")
  end

  def id
    user_id.to_i
  end

  def employee_id
    self[:employee_id].to_i  
  end

  def self.current
    Thread.current[:user]
  end
  def self.current=(user)
    Thread.current[:user] = user
  end
end