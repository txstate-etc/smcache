require 'test_helper'

class InstagramPostsControllerTest < ActionController::TestCase
  setup do
    @instagram_post = instagram_posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:instagram_posts)
  end

  test "should create instagram_post" do
    assert_difference('InstagramPost.count') do
      post :create, instagram_post: { caption: @instagram_post.caption, height: @instagram_post.height, postid: @instagram_post.postid, posttime: @instagram_post.posttime, url: @instagram_post.url, width: @instagram_post.width }
    end

    assert_response 201
  end

  test "should show instagram_post" do
    get :show, id: @instagram_post
    assert_response :success
  end

  test "should update instagram_post" do
    put :update, id: @instagram_post, instagram_post: { caption: @instagram_post.caption, height: @instagram_post.height, postid: @instagram_post.postid, posttime: @instagram_post.posttime, url: @instagram_post.url, width: @instagram_post.width }
    assert_response 204
  end

  test "should destroy instagram_post" do
    assert_difference('InstagramPost.count', -1) do
      delete :destroy, id: @instagram_post
    end

    assert_response 204
  end
end
