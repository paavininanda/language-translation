class ArticlesController < ApplicationController
  include StrongParams

  before_action :set_article, only: [:show, :edit, :update, :destroy, :publish, :unpublish]

  load_and_authorize_resource

  respond_to :html, :json

  def new
    @article = Article.new
    @article.audios.build
    @categories = Category.all
  end

  def index
    @filterrific = initialize_filterrific(
      Article,
      params[:filterrific],
      select_options: {
        with_language_id: Language.options_for_select,
        with_category_id: Category.options_for_select
            
      }
    ) or return
      @articles = @filterrific.find.page(params[:page])

    # Respond to html for initial page load and to js for AJAX filter updates.
    respond_to do |format|
      format.html
      format.js
    end
   end

  def create
    @article = Article.new(article_params)

    respond_with(@category) do |format|
      if @article.save
        flash[:notice] = "Article successfully created."
        format.html { redirect_to article_path(@article) }
      else
        flash[:error] = "Sorry, failed to create article due to errors."
        @categories = Category.all
        format.html { render 'new' }
      end
    end
  end

  def edit
    @categories = Category.all
  end

  def destroy
    @article.delete

    redirect_to articles_path
  end

  def show
  end

  def update
    @article = Article.find(params[:id])
    
    respond_with(@article) do |format|
      if @article.update(article_params)
        flash[:notice] = "Article successfully updated."
        format.html { redirect_to article_path(@article) }
      else
        flash[:error] = "Sorry, failed to update article due to errors."
        @categories = Category.all
        format.html { render 'edit' }
      end
    end
  end

  def publish
    respond_with(@article) do |format|
      if @article.published!
        flash[:notice] = "The article has been published."

        format.html { redirect_to article_path(@article) }
        format.json { render json: @article, location: article_path(@article) }
      else
        flash[:error] = "Failed to publish the article, please try again."

        format.html { redirect_to article_path(@article) }
        format.json { render json: @article.errors.to_hash(true), status: :unprocessable_entity }
      end
    end
  end

  def unpublish
    respond_with(@article) do |format|
      if @article.draft!
        flash[:notice] = "The article has been drafted."

        format.html { redirect_to article_path(@article) }
        format.json { render json: @article, location: article_path(@article) }
      else
        flash[:error] = "Failed to draft the article, please try again."

        format.html { redirect_to article_path(@article) }
        format.json { render json: @article.errors.to_hash(true), status: :unprocessable_entity }
      end
    end
  end

  private
  def set_article
    @article = Article.includes(:category, :language, :audios).find(params[:id])
  end

  def article_params
    params.require(:article).permit(:picture, :category_id, :language_id, :english, :phonetic, :state, audios_attributes: [:id, :audio, :content, :article_id, :created_at , :updated_at, :audio_cache, :_destroy])
  end
end
