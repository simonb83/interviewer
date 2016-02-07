module ApplicationHelper

  def current_auth_resource
    if recruiter_signed_in?
      current_recruiter
    elsif admin_signed_in?
      current_admin
    end
  end

  def current_ability
      @current_ability ||= Ability.new(current_auth_resource)
  end

end
