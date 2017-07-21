ActiveAdmin.register Site do
  permit_params :name, :country_id

  form do |f|
    f.inputs "New Site" do
      f.input :country, label: 'Country'
      f.input :name
    end
    f.actions
  end

end
