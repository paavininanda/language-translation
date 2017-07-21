ActiveAdmin.register Article do
  permit_params :english, :phonetic, :language_id, :category_id, :picture

  form do |f|
    f.inputs "New Article", :multipart => true do
      f.input :picture, :as => :file, :hint => image_tag(f.object.picture.url)
      f.input :picture_cache, :as => :hidden
      f.input :english
      f.input :phonetic
      f.input :language
      f.input :category
    end
    f.actions
  end
end