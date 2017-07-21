class API::ArticlesController < API::BaseController
  include StrongParams

  def index
    authorize_user! :read, Article

    if params[:q].blank?
      @records = Article.page(params[:page]).per(20)
    else
      @records = Article.article_search(params[:q]).page(params[:page]).per(20)
    end

    respond_with(@records) do |format|
      format.json { render json: @records, root: :articles }
    end
  end

  def show
    authorize_user! :read, Article

    @record = Article.find(params[:id])

    respond_with(@record) do |format|
      format.json { render json: @record, root: :article }
    end
  end

  def create
    authorize_user! :create, Article

    @record = Article.new(article_params)

    respond_with(@record) do |format|
      if @record.save
        format.json { render json: @record, root: :article, status: :created }
      else
        format.json { render json: { errors: @record.errors.to_hash(true) }, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize_user! :update, Article

    @record = Article.find(params[:id])

    respond_with(@record) do |format|
      if @record.update(article_params)
        format.json { render json: @record, root: :article }
      else
        format.json { render json: { errors: @record.errors.to_hash(true) }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize_user! :destroy, Article

    @record = Article.find(params[:id])

    respond_with(@record) do |format|
      if @record.destroy
        format.json { render json: {  article: {id: @record.id, deleted: true} } }
      else
        format.json { render json: { errors: @record.errors.to_hash(true) }, status: :unprocessable_entity }
      end
    end
  end

end
