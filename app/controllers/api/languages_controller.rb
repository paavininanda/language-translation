class API::LanguagesController < API::BaseController

  def index
    authorize_user! :read, Language

    @records = Language.page(params[:page]).per(20)

    respond_with(@records) do |format|
      format.json { render json: @records, root: :languages }
    end
  end

  def show
    authorize_user! :read, Language

    @record = Language.find(params[:id])

    respond_with(@record) do |format|
      format.json { render json: @record, root: :language }
    end
  end

  def create
    authorize_user! :create, Language

    @record = Language.new(language_params)

    respond_with(@record) do |format|
      if @record.save
        format.json { render json: @record, root: :language, status: :created }
      else
        format.json { render json: { errors: @record.errors.to_hash(true) }, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize_user! :update, Language

    @record = Language.find(params[:id])

    respond_with(@record) do |format|
      if @record.update(language_params)
        format.json { render json: @record, root: :language }
      else
        format.json { render json: { errors: @record.errors.to_hash(true) }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize_user! :destroy, Language

    @record = Language.find(params[:id])

    respond_with(@record) do |format|
      if @record.destroy
        format.json { render json: {  language: {id: @record.id, deleted: true} } }
      else
        format.json { render json: { errors: @record.errors.to_hash(true) }, status: :unprocessable_entity }
      end
    end
  end

  private
  def language_params
    params.require(:language).permit(:name)
  end
end
