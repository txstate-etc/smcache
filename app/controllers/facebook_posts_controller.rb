class FacebookPostsController < ApplicationController

  # GET /facebook_posts
  # GET /facebook_posts.json
  def index
    @facebook_posts = FacebookPost.photoOrLink.recent

    json = @facebook_posts.as_json
    json.each do |j|
      fname = j.delete(:image_filename)
      j['image_proxy'] = facebook_img_url(j['id'], fname) rescue nil
    end
    render json: json
  end

  def img
    @post = FacebookPost.find(params[:id])
    expires_in 5.minutes
    proxy(@post.image_url) if stale?(@post, public: true)
  end

end
