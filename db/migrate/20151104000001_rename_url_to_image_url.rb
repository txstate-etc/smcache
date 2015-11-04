class RenameUrlToImageUrl < ActiveRecord::Migration
  def change
    rename_column :instagram_posts, :url, :image_url
    rename_column :facebook_posts, :url, :image_url
  end
end
