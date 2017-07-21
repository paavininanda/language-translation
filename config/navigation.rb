# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'

  # Define the primary navigation
  navigation.items do |primary|
    primary.dom_class = 'MainMenu sidebarNav'

    # Superadmins, Admins, Volunteers, and Contributors have access to the Articles.
    if current_user and current_user.has_any_role? :superadmin, :admin, {name: :volunteer, resource: :any}, {name: :contributor, resource: :any}
      primary.item :articles, "Articles", articles_path, highlights_on: :subpath do |sub|
        sub.dom_class = 'nav nav-pills'
        sub.item :new_article, 'New article', new_article_path
      end
    end

    # Superadmins, Admins, and Volunteers have access to members. Admins and Volunteers have access to those that belong to their own organization only.
    if current_user and current_user.has_any_role? :superadmin, :admin, {name: :volunteer, resource: :any}
      primary.item :users, 'Members', users_path, highlights_on: :subpath do |sub|
        sub.dom_class = 'nav nav-pills'
        sub.item :user, 'Invite Member', new_user_path
      end
    end

  end
end
