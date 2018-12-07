class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout 'blacklight'

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def require_login
    unless current_user
        redirect_to dashboard_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    #redirect_to dashboard_url, :alert => exception.message
    render template: "bibliographies/_not_permitted", locals: {alert: exception.message}
  end
end
