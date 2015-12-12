class FacebookPostsController < ApplicationController

  # GET /facebook_posts
  # GET /facebook_posts.json
  def index
    @facebook_posts = FacebookPost.photoOrLink.recent

    json = @facebook_posts.as_json
    json.each do |j|
      j['image_proxy'] = facebook_img_url(j['id'], File.basename(URI.parse(j['image_url']).path)) rescue nil
    end
    render json: json
  end

  def img
    @post = FacebookPost.find(params[:id])
    proxy(@post.image_url)
  end

end
