class HealthCheckController < ActionController::Base

  def index
    render text: "true"
  end

  protected
  def allow_http?
    true
  end

end