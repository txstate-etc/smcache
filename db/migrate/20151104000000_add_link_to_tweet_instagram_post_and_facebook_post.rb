class AddLinkToTweetInstagramPostAndFacebookPost < ActiveRecord::Migration
  def change
    add_column :tweets, :link, :text
    add_column :instagram_posts, :link, :text
    add_column :facebook_posts, :link, :text
  end
end
