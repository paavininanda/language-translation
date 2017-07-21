def create
    @user = current_user

    @list = @user.lists.new(list_params)
    @list.owner = current_user

    respond_to do |format|
        if @list.save
            format.html { redirect_to [@user, @list], notice: 'List was successfully created.' }
            format.json { render :show, status: :created, location: @list }
        else
            format.html { render :new }
            format.json { render json: @list.errors, status: :unprocessable_entity }
        end
    end
end

