class AllController < ApplicationController

  def index
    @instagram_posts = InstagramPost.recent
    @tweets = Tweet.recent_combined
    @facebook_posts = FacebookPost.recent
    
    render json: {
      instagram: @instagram_posts,
      twitter: @tweets,
      facebook: @facebook_posts
    }
  end

end
