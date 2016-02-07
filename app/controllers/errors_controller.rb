class ErrorsController < ApplicationController

  def not_found
    render status: 404, formats: [:html]
  end

  def server_error
    render status: 500, formats: [:html]
  end

  def internal_error
    render 'server_error', status: 422, formats: [:html]
  end

  def access_denied
    render status: 403, formats: [:html]
  end

end