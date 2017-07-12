module ApplicationHelper

	def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
    	if message.is_a?(Hash)
    		concat(
    			content_tag(:div, class: "alert #{bootstrap_class_for(msg_type.to_sym)} fade in alert-dismissible") do 
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
	              concat( content_tag(:ul) do
	              	message.reject{|attribute, message_array| message_array.blank?}.collect{|attribute, message_array| 
	              		concat(content_tag(:li, attribute.to_s.gsub('_', ' ').titleize, class: 'no_bullets'))
              			concat( content_tag(:ul) do 
              				message_array.collect{|m| concat(content_tag(:li, m))}
              			end)
	              	}
	              end) 
          end)
    	elsif message.is_a?(String)
    		concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type.to_sym)} fade in alert-dismissible") do 
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message 
            end)
    	end
      
    end
    nil
  end

  def date_format(date)
    date.strftime("%m-%d-%Y")
  end

  def date_time_format(date)
    date.strftime("%m-%d-%Y %H:%M")
  end

  def time_format(date)
    date.strftime("%H:%M")
  end
  
end
