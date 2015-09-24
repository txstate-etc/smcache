class AddVideoToInstagramPost < ActiveRecord::Migration
  def change
    add_column :instagram_posts, :video_url, :text
    add_column :instagram_posts, :video_width, :integer
    add_column :instagram_posts, :video_height, :integer
  end
end
