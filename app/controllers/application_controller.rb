class ApplicationController < ActionController::Base
    include Pundit 
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    protect_from_forgery with: :exception
	before_action :configure_permitted_parameters, if: :devise_controller? 

	helper_method :current_user, :logged_in?

private 
	def user_not_authorized
		flash[:alert] = "Access denied."
		redirect_to (request.referrer || new_user_path)
	end

protected 
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :profile, :city, :country, :role]) 
		devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile, :city, :country,:role] )
	end
end
