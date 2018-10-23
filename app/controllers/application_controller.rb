class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout 'blacklight'

  def after_sign_in_path_for(resource)
    bibliographies_path
  end
end
