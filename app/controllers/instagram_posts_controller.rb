class InstagramPostsController < ApplicationController

  # GET /instagram_posts
  # GET /instagram_posts.json
  def index
    @instagram_posts = InstagramPost.recent

    render json: @instagram_posts
  end

end
