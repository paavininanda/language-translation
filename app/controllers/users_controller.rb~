class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :destroy, :update]
  load_and_authorize_resource

  def index
    if params[:q].blank?
      @users = User.accessible_by(current_ability).page(params[:page]).per(20)
    else
      @users = User.accessible_by(current_ability).user_search(params[:q]).page(params[:page]).per(20)
    end

    @pagination = { current_page: @users.current_page, total_pages: @users.total_pages }
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
        format.html { redirect_to users_path }
      else
        format.html { render 'new' }
      end
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy

    redirect_to users_path
  end

  #####CUSTOM METHODS#####

  #Called from Users Index: app/assets/javascripts/components/users/index.js.jsx.coffee
  # It receives the user_id and approves/disapproves the user, then returns the Users list.
  def approve_user
    @user = User.find(params[:user_id])
    @user.login_approval_at = Time.now
    respond_to do |format|
      if @user.save
        format.json { render json: User.accessible_by(current_ability), status: :ok }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  def disapprove_user
    @user = User.find(params[:user_id])
    @user.login_approval_at = nil
    respond_to do |format|
      if @user.save
        format.json { render json: User.accessible_by(current_ability), status: :ok }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  #Called from Users Show: app/assets/javascripts/components/users/show.js.jsx.coffee
  # It receives the user_id and grants/revokes admin rights, then returns the user's roles.
  def grant_admin
    @user = User.find(params[:user_id])
    @user.add_role :admin
    respond_to do |format|
      if @user.save
        format.json { render json: @user.roles.map{|a| a.name}, status: :ok }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def revoke_admin
    @user = User.find(params[:user_id])
    @user.remove_role :admin
    respond_to do |format|
      if @user.save
        format.json { render json: @user.roles.map{|a| a.name}, status: :ok }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
def avatar_url(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      default_url = "#{root_url}images/guest.png"
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
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
