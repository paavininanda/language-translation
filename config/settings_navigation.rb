# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'

  # Define the primary navigation
  navigation.items do |primary|

    # Superadmins have access to all organizations
    if current_user and current_user.has_role? :superadmin
      primary.item :organizations, "Organizations", organizations_path, highlights_on: :subpath do |sub|
        sub.dom_class = 'nav nav-pills'
        sub.item :new_organization, 'New Organization', new_organization_path
      end
    end

    # Admins have access to their organization only
    if current_user and current_user.has_role? :admin
      primary.item :organizations, "My Organization", organizations_path
    end

    # Superadmins, Admins have access to Countries. Admins have access to those that belong to their organization only.
    if current_user and current_user.has_any_role? :superadmin, :admin
      primary.item :countries, "Countries", countries_path, highlights_on: :subpath do |sub|
        sub.dom_class = 'nav nav-pills'
        sub.item :countries, 'New country', new_country_path
      end
    end

    # Superadmins, Admins have access to Sites. Admins have access to those that belong to their organization only.
    if current_user and current_user.has_any_role? :superadmin, :admin
      primary.item :sites, "Sites", sites_path, highlights_on: :subpath do |sub|
        sub.dom_class = 'nav nav-pills'
        sub.item :new_site, 'New site', new_site_path
      end
    end

    # Superadmins, Admins have access to Assign role. 
    if current_user and current_user.has_any_role? :superadmin, :admin
      primary.item :sites, "Assign Role", sites_path, highlights_on: :subpath do |sub|
        sub.dom_class = 'nav nav-pills'
        sub.item :new_site, 'New site', new_site_path
      end
    end

    # Volunteers have access to the site they belong to.
    if current_user and current_user.has_role? :volunteer, :any
      primary.item :sites, "My Site", sites_path
    end

    # Superadmins, Admins, and Volunteers have access to all Languages.
    if current_user and current_user.has_any_role? :superadmin, :admin, {name: :volunteer, resource: :any}
      primary.item :languages, "Languages", languages_path, highlights_on: :subpath do |sub|
        sub.dom_class = 'nav nav-pills'
        sub.item :new_language, 'New language', new_language_path
      end
    end

    # SUperadmins, Admins, and Volunteers have access to all Categories.
    if current_user and current_user.has_any_role? :superadmin, :admin, {name: :volunteer, resource: :any}
      primary.item :categories, "Categories", categories_path, highlights_on: :subpath do |sub|
        sub.dom_class = 'nav nav-pills'
        sub.item :new_category, 'New Category', new_category_path
      end
    end

# Superadmins, Admins have access to Activities..
    if current_user and current_user.has_any_role? :superadmin, :admin
      primary.item :activities, "Activities", activities_path
    end

    primary.dom_class = 'nav sidebarNav'
  end
end
