require 'test_helper'

class TweetsControllerTest < ActionController::TestCase
  setup do
    @tweet = tweets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tweets)
  end

  test "should create tweet" do
    assert_difference('Tweet.count') do
      post :create, tweet: { display_name: @tweet.display_name, favorite: @tweet.favorite, profile_image: @tweet.profile_image, screen_name: @tweet.screen_name, text: @tweet.text, tweetid: @tweet.tweetid, tweettime: @tweet.tweettime }
    end

    assert_response 201
  end

  test "should show tweet" do
    get :show, id: @tweet
    assert_response :success
  end

  test "should update tweet" do
    put :update, id: @tweet, tweet: { display_name: @tweet.display_name, favorite: @tweet.favorite, profile_image: @tweet.profile_image, screen_name: @tweet.screen_name, text: @tweet.text, tweetid: @tweet.tweetid, tweettime: @tweet.tweettime }
    assert_response 204
  end

  test "should destroy tweet" do
    assert_difference('Tweet.count', -1) do
      delete :destroy, id: @tweet
    end

    assert_response 204
  end
end
