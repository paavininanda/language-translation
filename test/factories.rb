FactoryGirl.define do

  factory :article do
    language
    category
    sequence(:english)        { |n| "English Text #{n}" }
    sequence(:phonetic)       { |n| "Phonetic Text #{n}" }
  end

  factory :audio do
    audio                     Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'audio', 'test_audio.wav'))
  end

  factory :category do
    sequence(:name) { |n| "test_category_#{n}" }
  end

  factory :country do
    organization
    user
    sequence(:name) { |n| "test_location_#{n}" }
  end

  factory :language do
    sequence(:name) { |n| "test_language_#{n}" }
  end

  factory :organization do
    sequence(:name) { |n| "test_organization_#{n}" }
  end

  factory :site do
    country
    sequence(:name) { |n| "test_site_#{n}" }
  end

  factory :user do
    organization
    sequence(:email)          { |n| "test_user_#{n}@gmail.com" }
    sequence(:first_name)     { |n| "fname#{n}" }
    sequence(:last_name)      { |n| "lname#{n}" }
    password                  "testing123"
    authentication_token      { Devise.friendly_token }
    sequence(:username)       { |n| "uname#{n}" }
    login_approval_at         { 2.weeks.ago }
    avatar                    Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'picture', 'logo.jpg'))
  end
end
