class PasswordsController < Devise::PasswordsController
  layout "no_user"

  def create
    super
  end

  protected
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_user_session_path if is_navigational_format?
  end
end