require 'test_helper'

module Contributor
  class ArticlesControllerTest < ActionController::TestCase
    tests ArticlesController

    include Devise::TestHelpers

    setup do
      @user = create(:user)
      @user.add_role :contributor

      @language = create(:language, name: 'Chuukese')
      @category = create(:category)

      sign_in @user
    end

    def teardown
      User.delete_all
      Article.delete_all
    end

    test "index should render correct template and layout" do
      get :index

      assert_template :index
      assert_template layout: "layouts/application"
    end

    test "Cannot show publish select box" do
      get :new

      assert_select "select#article_state", 0
    end

    test "should create photo as draft article" do
      post :create,
           article: {
               category_id: @category.id,
               english: 'Knife',
               phonetic: "Pihiya",
               language_id: @language.id,
               picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'picture', 'logo.jpg')),
               state: "draft"
           }

      assert_redirected_to article_path(assigns(:article))

      assert_equal "draft", assigns(:article).state
    end

  end
end
