class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :destroy, :update]
  load_and_authorize_resource
  respond_to :html, :json

  def index
    @users = User.accessible_by(current_ability)
    if params[:search]
      @users = User.search(params[:search]).order("created_at DESC")
    else
      @users = User.accessible_by(current_ability).order('created_at DESC')
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    ## Set default organization
    @user.organization = current_user.organization
    @user.no_invitation = user_params[:no_invitation]

    respond_to do |format|
      if @user.save
        flash[:notice] = "User successfully created."
        format.html { redirect_to users_path }
      else
        flash[:error] = "Sorry, failed to create user due to errors."
        format.html { render 'new' }
      end
    end
  end

  def update
    respond_with(@category) do |format|
      if @user.update(user_params)
        flash[:notice] = "User successfully updated."
        format.html { redirect_to @user }
      else
        flash[:error] = "Sorry, failed to update user due to errors."
        format.html { render 'edit' }
      end
    end
  end

  def destroy
    @user.destroy

    redirect_to users_path
  end

  def approve_user
    if current_user.has_role? :superadmin or current_user.has_role? :admin
      if params[:user_id].present?
        @user = User.find(params[:user_id])
      elsif params[:username].present?
        @user = User.find_by_username(params[:username])
      end
      
      if @user.present?
        @user.login_approval_at = Time.now
        respond_to do |format|
          if @user.save
            flash[:notice] = "User has been approved."
            format.json { render json: User.accessible_by(current_ability), status: :ok }
            format.html { redirect_to users_path }
          else
            flash[:error] = "Sorry, failed to approve user due to errors."
            format.json { render json: @user.errors, status: :unprocessable_entity}
            format.html { redirect_to users_path }
          end
        end
      else
        flash[:error] = "User not available."
        redirect_to users_path
      end
    else
      flash[:error] = "User does not have sufficient permission to perform this action."
      redirect_to users_path
    end
  end

  def disapprove_user
    if current_user.has_role? :superadmin or current_user.has_role? :admin
      if params[:user_id].present?
        @user = User.find(params[:user_id])
      elsif params[:username].present?
        @user = User.find_by_username(params[:username])
      end

      if @user.present?
        @user.login_approval_at = nil
        respond_to do |format|
          if @user.save
            flash[:notice] = "User has been disapproved."
            format.json { render json: User.accessible_by(current_ability), status: :ok }
            format.html { redirect_to users_path }
          else
            flash[:error] = "Sorry, failed to disapprove user due to errors."
            format.json { render json: @user.errors, status: :unprocessable_entity}
            format.html { redirect_to users_path }
          end
        end
      else
        flash[:error] = "User not available."
        redirect_to users_path
      end
    else
      flash[:error] = "User does not have sufficient permission to perform this action."
      redirect_to users_path
    end
  end

  def grant_admin
    if current_user.has_role? :superadmin
      if params[:user_id].present?
        @user = User.find(params[:user_id])
      elsif params[:username].present?
        @user = User.find_by_username(params[:username])
      end

      if @user.present?
        @user.add_role :admin
        respond_to do |format|
          if @user.save
            flash[:notice] = "User granted admin permission."
            format.json { render json: @user.roles.map{|a| a.name}, status: :ok }
            format.html { redirect_to users_path }
          else
            flash[:error] = "Sorry, failed to grant admin permission due to errors."
            format.json { render json: @user.errors, status: :unprocessable_entity }
            format.html { redirect_to users_path }
          end
        end
      else
        flash[:error] = "User not available."
        redirect_to users_path
      end
    else
      flash[:error] = "User does not have sufficient permission to perform this action."
      redirect_to users_path
    end
  end

  def revoke_admin
    if current_user.has_role? :superadmin
      if params[:user_id].present?
        @user = User.find(params[:user_id])
      elsif params[:username].present?
        @user = User.find_by_username(params[:username])
      end

      if @user.present?
        @user.remove_role :admin
        respond_to do |format|
          if @user.save
            flash[:notice] = "Admin permissions revoked for user."
            format.json { render json: @user.roles.map{|a| a.name}, status: :ok }
            format.html { redirect_to users_path }
          else
            flash[:error] = "Sorry, failed to revoke admin permission due to errors."
            format.json { render json: @user.errors, status: :unprocessable_entity }
            format.html { redirect_to users_path }
          end
        end
      else
        flash[:error] = "User not available."
        redirect_to users_path
      end
    else
      flash[:error] = "User does not have sufficient permission to perform this action."
      redirect_to users_path
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :username, :location, :lang, :contact, :gender, :no_invitation, :password, :avatar)
  end
end
