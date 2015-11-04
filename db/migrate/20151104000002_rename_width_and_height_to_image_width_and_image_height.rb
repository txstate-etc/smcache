class RenameWidthAndHeightToImageWidthAndImageHeight < ActiveRecord::Migration
  def change
    rename_column :instagram_posts, :width, :image_width
    rename_column :instagram_posts, :height, :image_height
    rename_column :facebook_posts, :width, :image_width
    rename_column :facebook_posts, :height, :image_height
  end
end
