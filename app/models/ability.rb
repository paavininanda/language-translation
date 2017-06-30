class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    @user = (user ||= User.new) # guest user (not logged in)

    # following roles exist: superadmin, admin, volunteer, contributor, guest, non-users

    if user.has_role? :superadmin
      #Superadmins can do anything. They can also access the ActiveAdmin interface via http://the_site_address/admin
      can :manage, :all
      can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: :superadmin

    elsif user.has_role? :admin
      #Admins all belong to an organization. They can manage Languages, Categories and Articles freely,
      # but they can only manage the Countries, Sites, and Users that belong to their own organization
      # as well as read and update the organization they belong to.
      can :manage, [Language, Category, Article]
      can [:read, :update], Organization,
          id: @user.organization.id
      can :manage, [Country, User],
          organization_id: @user.organization.id
      can :new, Site
      can :manage, Site,
          country_id: @user.organization.countries.map { |a| a.id }

    elsif user.has_role? :volunteer, :any
      #Volunteers all belong to an Organization as well as a Site. They can only read Languages and Categories, but they can
      # manage Articles. They can also read other users, but they are only allowed to manage the contributors that belong
      # to the same organization. They do not have access to other Countries, but they can read and update the Site they belong to.
      can :read, [Language, Category]
      can :manage, [Article]
      can :read, User,
          organization_id: @user.organization.id
      can :manage, User,
          organization_id: @user.organization.id,
          id: User.with_any_role({name: :contributor, resource: :any}, :guest).map { |a| a.id }
      can [:read, :update], Site,
          id: Site.with_role(:volunteer, @user).map { |a| a.id }

    elsif user.has_role? :contributor, :any
      #Contributors all belong to an Organization as well as a Site. They can only read, create, and update Articles
      can [:read, :create, :update], Article

    else
      #Guest users are only allowed to read Articles
      can :read, Article

      #Non-users do not have access to any of the pages but the sign up page.
    end
  end
end
