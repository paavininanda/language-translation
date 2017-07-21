class API::CategoriesController < API::BaseController

  def index
    authorize_user! :read, Category

    @records = Category.page(params[:page]).per(20)

    respond_with(@records) do |format|
      format.json { render json: @records, root: :categories }
    end
  end

  def show
    authorize_user! :read, Category

    @record = Category.find(params[:id])

    respond_with(@record) do |format|
      format.json { render json: @record, root: :category }
    end
  end

  def create
    authorize_user! :create, Category

    @record = Category.new(category_params)

    respond_with(@record) do |format|
      if @record.save
        format.json { render json: @record, root: :category, status: :created }
      else
        format.json { render json: { errors: @record.errors.to_hash(true) }, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize_user! :update, Category

    @record = Category.find(params[:id])

    respond_with(@record) do |format|
      if @record.update(category_params)
        format.json { render json: @record, root: :category }
      else
        format.json { render json: { errors: @record.errors.to_hash(true) }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize_user! :destroy, Category

    @record = Category.find(params[:id])

    respond_with(@record) do |format|
      if @record.destroy
        format.json { render json: {  category: {id: @record.id, deleted: true} } }
      else
        format.json { render json: { errors: @record.errors.to_hash(true) }, status: :unprocessable_entity }
      end
    end
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end
end
