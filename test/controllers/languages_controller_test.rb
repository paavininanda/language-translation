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

  test "should render new language input page" do
    get :new

    assert_template :new
    assert_template layout: "layouts/application"
  end

  test "index should display the correct languages based on search parameter" do
    language1 = create(:language, name: "test_language_1")
    language2 = create(:language, name: "test_language_2")
    language3 = create(:language, name: "test_language_3")
    post :index, search: "test_language"

    assert_equal "test_language_3", Language.search(assigns(:search)).order('created_at DESC')[0].name
    assert_equal "test_language_2", Language.search(assigns(:search)).order('created_at DESC')[1].name
    assert_equal "test_language_1", Language.search(assigns(:search)).order('created_at DESC')[2].name
  end

  test "should create language and go to its edit page" do
    assert_difference('Language.count') do
      post :create, language: {name: 'Chuukese'}
    end

    assert_equal "Chuukese", assigns(:language).name
    assert_equal "Language successfully created.", flash[:notice]
    assert_redirected_to edit_language_path(assigns(:language))
  end

  test "should not create language without its name" do
    assert_no_difference('Language.count') do
      post :create, language: {name: nil}
    end

    assert_equal "Sorry, failed to create language due to errors.", flash[:error]
    assert_template(:new)
  end

  test "should not create a duplicate language" do
    assert_difference('Language.count', 1) do
      2.times {
        post :create, language: {name: 'Sanskrit'}
      }
    end

    assert_equal "Sorry, failed to create language due to errors.", flash[:error]
    assert_template(:new)
  end

  test "should render blank page on requested language show method" do
    language = create(:language, name: "Sanskrit")

    get :show, {id: language.id, language: {name: "Sanskrit"} }

    assert_equal "Sanskrit", assigns(:language).name
    assert_template(expected = nil)
  end

  test "should update language name" do
    language = create(:language, name: "Sanskrit")

    put :update, {id: language.id, language: {name: "Swahili"} }

    assert_equal "Swahili", assigns(:language).name
    assert_equal "Language successfully updated.", flash[:notice]
    assert_redirected_to edit_language_path(assigns(:language))
  end

  test "should not update without language name" do
    language = create(:language, name: "Sanskrit")

    put :update, {id: language.id, language: {name: ""} }

    assert_empty assigns(:language).name
    assert_equal "Sorry, failed to update language due to errors.", flash[:error]
    assert_template(:edit)
  end

  test "should not update language name with duplicate entry" do
    language1 = create(:language, name: "Sanskrit")
    put :update, {id: language1.id, language: {name: "Swahili"}}
    assert_equal "Swahili", assigns(:language).name

    category2 = create(:language, name: "Tamil")
    put :update, {id: category2.id, language: {name: "Swahili"}}

    assert_equal "Sorry, failed to update language due to errors.", flash[:error]
    assert_template(:edit)
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
      assert_equal "Language has been deleted.", flash[:notice]
      assert_response :redirect
      assert_redirected_to languages_path
    end

    assert_nil Language.find_by_id(language.id)
    assert_nil Article.find_by_language_id(language.id)
    assert_nil Article.find_by_id(article.id)
  end

end
