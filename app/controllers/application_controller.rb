# encoding: UTF-8

class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery

#Re-implement force_ssl to allow override in controllers
def self.force_ssl(options = {})
    host = options.delete(:host)
    before_filter(options) do
      if !request.ssl? && !Rails.env.development? && !Rails.env.test? && !(respond_to?(:allow_http?) && allow_http?)
        redirect_options = {:protocol => 'https://', :status => :moved_permanently}
        redirect_options.merge!(:host => host) if host
        redirect_options.merge!(:params => request.query_parameters)
        redirect_to redirect_options
      end
    end
  end

force_ssl

#Get current recruiter
before_filter :get_user

def get_user
  if admin_signed_in?
    @admin = current_admin
  elsif
    @recruiter = current_recruiter
    flash[:alert]= "Tu cuenta ha sido suspendida. Por favor habla con el administrador de tu empresa o contáctanos <a href=#{recruiter_technical_support_path(@recruiter)}>aquí</a> para reactivarla.".html_safe unless @recruiter.active?
  end
end

#Method for enabling routing to home page
def home
end

#Redirect recruiters to their own account page after sign-in
def after_sign_in_path_for(user)
  if user.is_a?(Recruiter) && user.new_user
    recruiter_change_password_path(user)
  else
    user
  end
end

def help
  Helper.instance
end

rescue_from CanCan::AccessDenied do |exception|
  # Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
  # # ...
  redirect_to '/403'
end

class Helper
  include Singleton
  include ActionView::Helpers::TextHelper
end

end
