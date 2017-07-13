module CreatorModifier

	def created_user_name
  	if user = User.find(self.created_by) rescue nil
  	 return user.first_name
    else
      nil
    end
  end

  def last_upated_user_name
  	if user = User.find(self.last_updated_by) rescue nil
  	 return user.first_name
    else
      nil
    end
  end
end