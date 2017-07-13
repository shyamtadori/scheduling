class PilotsHitch < ActiveRecord::Base
	belongs_to :hitch
	belongs_to :pilot, , class_name: "User", foreign_key: "employee_id"
end
