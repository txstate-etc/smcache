class AddMediaToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :image_url, :text
    add_column :tweets, :image_width, :integer
    add_column :tweets, :image_height, :integer
    add_column :tweets, :video_url, :text
  end
end
