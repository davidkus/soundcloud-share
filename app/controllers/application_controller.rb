class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  decent_configuration { strategy DecentExposure::StrongParametersStrategy }

  set_callback :logging_in_user, :on_login

  def pundit_user
    current_or_guest_user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end

  private

  def user_not_authorized
    flash[:alert] = I18n.t 'common.unauthorized_message'
    redirect_to(request.referrer || root_path)
  end

  def on_login
    RoomService.transfer_permissions guest_user, current_user
  end
end
