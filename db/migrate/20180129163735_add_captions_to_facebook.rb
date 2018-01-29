class AddCaptionsToFacebook < ActiveRecord::Migration
  def change
    add_column :facebook_posts, :video_embed_html, :text, :limit => 65000, :null => false
  end
end
