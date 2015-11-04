class FacebookPostsController < ApplicationController

  # GET /facebook_posts
  # GET /facebook_posts.json
  def index
    @facebook_posts = FacebookPost.recent

    render json: @facebook_posts
  end

end
