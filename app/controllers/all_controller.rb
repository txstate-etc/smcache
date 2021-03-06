class AllController < ApplicationController

  def index
    @instagram_posts = InstagramPost.images.recent
    @tweets = Tweet.recent_combined
    @facebook_posts = FacebookPost.photoOrLink.recent

    @instagram_posts = @instagram_posts.as_json(:include => { :slides => { :except => [:id, :instagram_post_id] } })
    @instagram_posts.each do |j|
      j['image_proxy'] = instagram_img_url(j['id'], File.basename(URI.parse(j['image_url']).path)) rescue nil
    end

    # @tweets = @tweets.as_json
    # @tweets.each do |j|
    #   j['image_proxy'] = twitter_img_url(j['id'], File.basename(URI.parse(j['image_url']).path)) rescue nil
    # end

    @facebook_posts = @facebook_posts.as_json(:include => { :slides => { :except => [:id, :facebook_post_id] } })
    @facebook_posts.each do |j|
      fname = j.delete('image_filename')
      j['image_proxy'] = facebook_img_url(j['id'], fname) rescue nil
    end

    render json: {
      instagram: @instagram_posts,
      twitter: @tweets,
      facebook: @facebook_posts
    }
  end

end
