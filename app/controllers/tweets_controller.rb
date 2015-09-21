class TweetsController < ApplicationController

  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = (Tweet.recent.nofav + Tweet.recent.fav).sort { |a,b| b.tweettime <=> a.tweettime }

    render json: @tweets
  end

end
