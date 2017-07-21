require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  tests ArticlesController

  include Devise::TestHelpers

  setup do
    @user = create(:user)
    @user.add_role :admin
    @language = create(:language, name: 'Chuukese')
    sign_in @user
  end

  def teardown
    User.delete_all
    Article.delete_all
  end

  test "the truth" do
    assert true
  end

  test "index should render correct template and layout" do
    get :index

    assert_template :index
    assert_template layout: "layouts/application"
  end

  test "should create article and go to its show page" do
    category = create(:category)

    assert_difference('Article.count') do
      post :create,
           article: {
               category_id: category.id,
               english: 'Knife',
               phonetic: "Pihiya",
               language_id: @language.id,
               picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'picture', 'logo.jpg')),
               audios: [Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'audio', 'test_audio.wav')), Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'audio', 'test_audio.wav'))],
               state: "published"
           }
    end

    assert_redirected_to article_path(assigns(:article))
    assert_equal "Article successfully created.", flash[:notice]
    assert_equal "published", assigns(:article).state

  end

  test "should not create article without picture" do
    category = create(:category)

      post :create,
           article: {
               category_id: category.id,
               english: 'Knife',
               phonetic: "Pihiya",
               language_id: @language.id,
               audios: [Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'audio', 'test_audio.wav')), Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'audio', 'test_audio.wav'))],
               state: "published"
           }

    assert_equal "Sorry, failed to create article due to errors.", flash[:error]
    assert_template(:new)

  end

  test "should not create article without category_id" do

      post :create,
           article: {
               english: 'Knife',
               phonetic: "Pihiya",
               language_id: @language.id,
               picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'picture', 'logo.jpg')),
               audios: [Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'audio', 'test_audio.wav')), Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'audio', 'test_audio.wav'))],
               state: "published"
           }

    assert_equal "Sorry, failed to create article due to errors.", flash[:error]
    assert_template(:new)

  end

  test "should update article" do
    category = create(:category)

    article = Article.create!({
        language_id: @language.id,
        category_id: category.id,
        english: "Foods",
        phonetic: "Keema",
        picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'picture', 'logo.jpg'))
    })

    get :edit, {id: article.id}

    put :update,
           {
               id: article.id,
               article: {
                 phonetic: "Unavu",
                 state: "published"
               }
           }

    assert_redirected_to article_path(assigns(:article))
    assert_equal "Unavu", assigns(:article).phonetic
    assert_equal "Article successfully updated.", flash[:notice]
    assert_equal "published", assigns(:article).state
  end

  test "should not update article without category_id and picture" do
    category = create(:category)

    article = Article.create!({
        language_id: @language.id,
        category_id: category.id,
        english: "Foods",
        phonetic: "Keema",
        picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'picture', 'logo.jpg'))
    })

    get :edit, {id: article.id}

    put :update,
           {
               id: article.id,
               article: {
                 phonetic: "Unavu",
                 category_id: nil,
                 picture: nil,
                 state: "published"
               }
           }

    assert_equal "Sorry, failed to update article due to errors.", flash[:error]
    assert_template(:edit)
  end

  test "should delete article" do
    category = create(:category)

    article = Article.create!({
        language_id: @language.id,
        category_id: category.id,
        english: "Foods",
        phonetic: "Keema",
        picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'picture', 'logo.jpg'))
    })

    assert_difference('Article.count',-1) do
      delete :destroy, language_id: @language.id, id: article.id
      assert_response :redirect
    end

    assert_nil Article.find_by_id(article.id)
    assert_not_nil Language.find_by_id(@language.id)
  end

  test "article change state to publish" do
    @category = create(:category)
    @article = Article.create!({
      language_id: @language.id,
      category_id: @category.id,
      english: "Foods",
      phonetic: "Keema",
      picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'picture', 'logo.jpg'))
    })

    assert_equal "draft", @article.state

    post :publish, id: @article
    assert_equal "published", assigns(:article).state
    assert_equal "The article has been published.", flash[:notice]
    assert_redirected_to article_path(assigns(:article))
  end

  test "article change state to unpublish" do
    @category = create(:category)
    @article = Article.create!({
      language_id: @language.id,
      category_id: @category.id,
      english: "Foods",
      phonetic: "Keema",
      picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'picture', 'logo.jpg'))
    })

    @article.published!

    assert_equal "published", @article.state

    post :unpublish, id: @article
    assert_equal "draft", assigns(:article).state
    assert_equal "The article has been drafted.", flash[:notice]
  end

end
