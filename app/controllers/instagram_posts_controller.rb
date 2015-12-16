require "net/http"
require "uri"

class InstagramPostsController < ApplicationController

  # GET /instagram_posts
  # GET /instagram_posts.json
  def index
    @instagram_posts = InstagramPost.images.recent

    json = @instagram_posts.as_json
    json.each do |j|
      j['image_proxy'] = instagram_img_url(j['id'], File.basename(URI.parse(j['image_url']).path)) rescue nil
    end
    render json: json
  end

  def img
    @post = InstagramPost.find(params[:id])
    expires_in 5.minutes
    proxy(@post.image_url) if stale?(@post, public: true)
  end

end
