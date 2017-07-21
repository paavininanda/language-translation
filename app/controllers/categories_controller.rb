class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

  def index
    @categories = Category.all
    if params[:search]
      @categories = Category.search(params[:search]).order("created_at DESC")
    else
      @categories = Category.all.order('created_at DESC')
    end
  end

  def show
    respond_with(@product) do |format|
      format.html { render nothing: true }
    end
  end

  def new
    @category = Category.new
    respond_with(@category)
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    respond_with(@category) do |format|
      if @category.save
        flash[:notice] = "Category successfully created."
        format.html { redirect_to edit_category_path(@category) }
      else
        flash[:error] = "Sorry, failed to create category due to errors."
        format.html { render 'new' }
      end
    end
  end

  def update
    @category = Category.find(params[:id])

    respond_with(@category) do |format|
      if @category.update(category_params)
        flash[:notice] = "Category successfully updated."
        format.html { redirect_to edit_category_path(@category) }
      else
        flash[:error] = "Sorry, failed to update category due to errors."
        format.html { render 'edit' }
      end
    end
  end

  def destroy
    @category.destroy

    flash[:notice] = "Category has been deleted."
    respond_with(@category)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def category_params
    params.require(:category).permit(:name)
  end
end
