require 'test_helper'

class LanguagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  tests LanguagesController

  setup do
    @user = create(:user)
    @user.add_role :admin
    sign_in @user
  end

  def teardown
    User.delete_all
  end

  test "the truth" do
    assert true
  end

  test "index should render correct template and layout" do
    get :index

    assert_template :index
    assert_template layout: "layouts/application"
  end

  test "should create language and go to its show page" do
    assert_difference('Language.count') do
      post :create, language: {name: 'Chuukese'}
    end
    assert_redirected_to edit_language_path(assigns(:language))
  end

  test "should not create language without its name" do
    assert_no_difference('Language.count') do
      post :create, language: {name: nil}
    end
  end

  test "should not create a duplicate language" do
    assert_difference('Language.count', 1) do
      2.times {
        post :create, language: {name: 'Sanskrit'}
      }
    end
  end

  test "should delete language along with all photos under that language" do
    language = Language.create!({name: 'Sanskrit'})
    category = create(:category)

    article = Article.create!({
                                  language_id: language.id,
                                  category_id: category.id,
                                  english: "Foods",
                                  phonetic: "Keema",
                                  picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'picture', 'logo.jpg'))
                              })

    assert_difference('Language.count',-1) do
      delete :destroy, id: language.id
      assert_response :redirect
    end

    assert_nil Language.find_by_id(language.id)
    assert_nil Article.find_by_language_id(language.id)
    assert_nil Article.find_by_id(article.id)
  end

end
