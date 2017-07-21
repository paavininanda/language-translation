class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
 include PublicActivity::StoreController
 
 protect_from_forgery with: :exception



  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  before_action :authenticate_user!
  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  alias :authorize_user! authorize!

  rescue_from CanCan::AccessDenied, with: :unauthorized_action

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end

  protected

  def configure_devise_permitted_parameters
    registration_params = [:first_name, :last_name, :email,  :username, :password, :password_confirmation, :location,
                           :lang, :contact, :gender, :organization_id, :avatar, :avatar_cache, :remove_avatar]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(registration_params << :current_password)}
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(registration_params) }
    end
  end

  def unauthorized_action(exception)
    respond_to do |format| 
      format.html { redirect_to main_app.root_url, alert: exception.message}
      format.json { render json: { errors: [exception.message] }, status: :forbidden }
    end
  end
  
end
