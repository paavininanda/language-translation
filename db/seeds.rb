# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# must be taken care of at the time of production.

    organizations = Organization.create([
        { name: "Peace Corps"},
        { name: "Red Cross"},
        { name: "Habitat for Humanity"},
        { name: "Amnesty International"}
    ])

    users = User.create!([
        { organization: organizations.first, username: 'admin1' , first_name: 'Adam', last_name: 'Wilkins',
        login_approval_at: Time.now, password: 'admin1', password_confirmation: 'admin1', email: 'admin@min.main'},
        { organization: organizations.second, username: 'admin2' , first_name: 'Neil', last_name: 'Bohr',
        login_approval_at: Time.now, password: 'admin2', password_confirmation: 'admin2', email: 'ad@min.two'},
        { organization: organizations.fourth, username: 'superadmin', first_name: 'Super', last_name: 'Admin',
        login_approval_at: Time.now, password: 'superadmin', password_confirmation: 'superadmin', email: 'super@ad.min'},
        { organization: organizations.third, username: 'volunteer', first_name: 'Vol', last_name: 'Unteer',
        login_approval_at: Time.now, password: 'volunteer', password_confirmation: 'volunteer', email: 'vol@un.teer'},
        { organization: organizations.first, username: 'contrib', first_name: 'Con', last_name: 'Tributor',
        login_approval_at: Time.now, password: 'contributor', password_confirmation: 'contributor', email: 'con@tri.butor'}
    ])

    countries = Country.create([
        { organization: organizations.first, user: users.first, name: "Kenya"},
        { organization: organizations.second, user: users.second, name: "Micronesia"},
        { organization: organizations.third, name: "Haiti"},
        { organization: organizations.fourth, name: "Philippines"},
        { organization: organizations.first, user: users.first, name: "Nepal"}
    ])

    sites = Site.create([
        { country: countries.first, name: "Nairobi"},
        { country: countries.first, name: "Mombasa"},
        { country: countries.second, name: "Caroline Islands"},
        { country: countries.second, name: "Gilbert Islands"},
        { country: countries.third, name: "Port-au-Prince"},
        { country: countries.third, name: "Les Cayes"},
        { country: countries.fourth, name: "Manilla"},
        { country: countries.fourth, name: "Caloocan"},
        { country: countries.fifth, name: "Kathmandu"},
        { country: countries.fifth, name: "Pokhara"}
    ])

    categories = Category.create([
        {name: "Animals"},
        {name: "Vehicles"},
        {name: "Insects"},
        {name: "Astronomy"},
        {name: "Adjectives"},
        {name: "Shapes"},
        {name: "Food"},
        {name: "Landscape"},
        {name: "Tools"}
    ])

    languages = Language.create([
        {name: "Chuukese"},
        {name: "Swahili"},
        {name: "Pohnpeian"}
    ])

    User.find_by_username('admin1').add_role :admin
    User.find_by_username('admin2').add_role :admin
    User.find_by_username('superadmin').add_role :superadmin
    User.find_by_username('volunteer').add_role :volunteer, sites.fifth
    User.find_by_username('contrib').add_role :contributor, sites.first
