ActiveAdmin.register Country do
  permit_params :name, :organization_id, :user_id

  form do |f|
    f.inputs "New Country" do
      f.input :organization, label: 'Organization'
      f.input :user, label: 'Manager'
      f.input :name
    end
    f.actions
  end

end