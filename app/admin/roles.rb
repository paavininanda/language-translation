ActiveAdmin.register Role do
  actions :all, except: [:new, :update, :destroy] #Roles are to be managed inside the application

  index do
    selectable_column
    id_column
    column :name
    column :resource_type
    column :created_at
    column :updated_at
  end

end