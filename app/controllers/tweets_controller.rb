class TweetsController < ApplicationController

  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.recent_combined

    json = @tweets.as_json
    json.each do |j|
      j['image_proxy'] = twitter_img_url(j['id'], File.basename(URI.parse(j['image_url']).path)) rescue nil
    end
    render json: json
  end

  def img
    @post = Tweet.find(params[:id])
    proxy(@post.image_url)
  end

end
