module ActiveRecord
  module Timestamp      
    private
    def timestamp_attributes_for_update #:nodoc:
      [:last_update_date, :updated_at, :updated_on, :modified_at]
    end
    def timestamp_attributes_for_create #:nodoc:
      [:creation_date, :created_at, :created_on]
    end     
  end
end
 