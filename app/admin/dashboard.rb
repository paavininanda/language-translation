ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Countries" do
          Country.unscoped.order("name").map do |country|
            li link_to(country.name, admin_country_path(country))
          end
        end
      end

      column do
        panel "Sites" do
          Site.unscoped.order("country_id").map do |site|
            country_name = Country.find(site.country_id).name
            li link_to(site.name + " (" + country_name + ")", admin_site_path(site))
          end
        end
      end
    end

    columns do
      column do
        panel "Languages" do
          ul do
            Language.unscoped.order("name").map do |language|
              li link_to(language.name, admin_language_path(language))
            end
          end
        end
      end

      column do
        panel "Categories" do
          ul do
            Category.unscoped.order("name").map do |category|
              li link_to(category.name, admin_category_path(category))
            end
          end
        end
      end

      column do
        panel "Articles" do
          ul do
            Article.unscoped.order("updated_at").last(20).map do |article|
              language_name = if article.language_id then Language.find(article.language_id).name else 'Language not selected' end
              category_name = if article.category_id then Category.find(article.category_id).name else 'Category not selected' end
              li link_to(article.english + " (" + language_name + ", " + category_name + ")", admin_article_path(article))
            end
          end
        end
      end

      # column do
      #   panel "Info" do
      #     para "Welcome to ActiveAdmin."
      #   end
      # end
    end
  end # content
end
