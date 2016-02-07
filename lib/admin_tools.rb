module AdminTools

  def modify_attribute(attribute,value)
    if self.has_attribute?(attribute)
      begin
        self.update_attributes!(attribute => value)
        message = "#{attribute} updated to #{value} for #{self.class} with id #{self.id}"
        return true, message
      rescue ActiveRecord::RecordInvalid => e
        return false, e.message
      end
    else
      return false, "Attribute #{attribute} doesn't exist"
    end
  end

end