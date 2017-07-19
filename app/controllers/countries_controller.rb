class CountriesController < ApplicationController
  before_action :set_country, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

  def index
    if current_user.has_role? :superadmin
      @countries = Country.all
      if params[:search]
       @countries = Country.search(params[:search]).order("created_at DESC")
      else
       @countries = Country.all.order('created_at DESC')
      end
    else
      @countries = current_user.organization.countries
      if params[:search]
        @countries = Country.search(params[:search]).order("created_at DESC")
      else
        @countries = current_user.organization.countries.order('created_at DESC')
      end
    end
  end

  def show
  end

  def new
    @country = Country.new
  end

  def edit
  end

  def create
    @country = Country.new(country_params)
    @country.organization_id = current_user.organization.id

    respond_with(@country) do |format|
      if @country.save
        flash[:notice] = "Country successfully created."
        format.html { redirect_to @country }
      else
        flash[:error] = "Sorry, failed to create country due to errors."
        format.html { render 'new' }
      end
    end
  end

  def update
    respond_with(@country) do |format|
      if @country.update(country_params)
        flash[:notice] = "Country successfully updated."
        format.html { redirect_to @country }
      else
        flash[:error] = "Sorry, failed to update country due to errors."
        format.html { render 'edit' }
      end
    end
  end

  def destroy
    @country.destroy

    flash[:notice] = "Country has been deleted."
    redirect_to countries_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_country
    @country = Country.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def country_params
    params.require(:country).permit(:name, :user_id, :organization_id)
  end
end