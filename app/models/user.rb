class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  self.table_name = 'seagan.sg_ramco_employees_v'
  self.primary_key = "employee_id"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable
  devise :timeoutable, :timeout_in => 15.minutes
  # Setup accessible (or protected) attributes for your model



  
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

  def username
    user_name
  end

  def full_name
    (last_name || "") + ', ' + (first_name || "")
  end

  def id
    employee_id.to_i
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