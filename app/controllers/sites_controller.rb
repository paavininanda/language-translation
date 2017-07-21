class SitesController < ApplicationController
  load_and_authorize_resource

  def index
    current_user.organization.countries.each do |a|
      @sites << a.sites
  if params[:search]
    @sites = Site.search(params[:search]).order("created_at DESC")
  else
    @sites << a.sites.order('created_at DESC')
  end

   end
    @sites = @sites.page(params[:page]).per(20)
  end

  def show
    @site = Site.find(params[:id])
    @volunteers = User.with_role :volunteer, @site
    @contributors = User.with_role :contributor, @site
  end

  def new
    if current_user.has_role? :superadmin
      @countries = Country.all
    else
      @countries = current_user.organization.countries
    end

    @site = Site.new
  end

  def edit
    if current_user.has_role? :superadmin
      @countries = Country.all
    else
      @countries = current_user.organization.countries
    end

    @site = Site.find(params[:id])
  end

  def create
    @site = Site.new(site_params)

    if @site.save
      redirect_to @site
    else
      if current_user.has_role? :superadmin
        @countries = Country.all
      else
        @countries = current_user.organization.countries
      end
      render 'new'
    end
  end

  def update
    @site = Site.find(params[:id])

    if @site.update(site_params)
      redirect_to @site
    else
      render 'edit'
    end
  end

  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    redirect_to sites_path
  end


  #####CUSTOM METHODS#####

  #Called from the Sites Show: app/assets/javascripts/components/sites/show.js.jsx.coffee
  # It receives the :username, :site_id, and :act(action) and adds/removes the user as
  # a volunteer/contributor of the given site. It returns the volunteer/contributor list.
  def add_role
    @user = User.where(username: params[:username]).first
    @site = Site.find(params[:site_id])
    action = params[:act]

    if(action == 'volunteer')
      respond_to do |format|
        if @user.add_role :volunteer, @site
          format.json { render json: (User.with_role :volunteer, @site), status: :ok}
        else
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    elsif(action == 'contributor')
      respond_to do |format|
        if @user.add_role :contributor, @site
          format.json { render json: (User.with_role :contributor, @site), status: :ok}
        else
          format.json { render json: @user.errors, status: :unprocessable_entity}
        end
      end
    end
  end
  def remove_role
    @user = User.find(params[:user_id])
    @site = Site.find(params[:site_id])
    action = params[:act]

    if(action == 'volunteer')
      respond_to do |format|
        if @user.remove_role :volunteer, @site
          format.json { render json: (User.with_role :volunteer, @site), status: :ok}
        else
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    elsif(action == 'contributor')
      respond_to do |format|
        if @user.remove_role :contributor, @site
          format.json { render json: (User.with_role :contributor, @site), status: :ok}
        else
          format.json { render json: @user.errors, status: :unprocessable_entity}
        end
      end
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def site_params
    params.require(:site).permit(:name, :country_id)
  end
end
