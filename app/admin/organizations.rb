ActiveAdmin.register Organization do
  permit_params :name

  form do |f|
    f.inputs "New Organization" do
      f.input :name
    end
    f.actions
  end

end
