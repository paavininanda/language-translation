class LanguagesController < ApplicationController
  before_action :set_language, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

  def index
    @languages = Language.all

    if params[:search]
      @languages = Language.search(params[:search]).order("created_at DESC")
    else
      @languages = Language.all.order('created_at DESC')
    end
  end

  def show
    respond_to do |format|
      format.html { render nothing: true }
    end
  end

  def new
    @language = Language.new
  end

  def edit
  end

  def create
    @language = Language.new(language_params)

    respond_with(@language) do |format|
      if @language.save
        flash[:notice] = "Language successfully created."
        format.html { redirect_to edit_language_path(@language) }
      else
        flash[:error] = "Sorry, failed to create language due to errors."
        format.html { render 'new' }
      end
    end
  end

  def update
    respond_with(@language) do |format|
      if @language.update(language_params)
        flash[:notice] = "Language successfully updated."
        format.html { redirect_to edit_language_path(@language) }
      else
        flash[:error] = "Sorry, failed to update language due to errors."
        format.html { render 'edit' }
      end
    end
  end

  def destroy
    @language.destroy

    flash[:notice] = "Language has been deleted."
    redirect_to languages_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_language
    @language = Language.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def language_params
    params.require(:language).permit(:name)
  end
end
