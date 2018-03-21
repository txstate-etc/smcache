class Urltoolong < ActiveRecord::Migration
  def change
    remove_index :facebook_slides, [:facebook_post_id, :url] if index_exists?(:facebook_slides, [:facebook_post_id, :url])
    remove_index :instagram_slides, :url if index_exists?(:instagram_slides, :url)
    add_index :facebook_slides, [:facebook_post_id, :url], :length => {:url => 200}
    add_index :instagram_slides, :url, :length => {:url => 200}
    change_column :facebook_slides, :url, :text, :limit => 65000, :null => true, :default => nil
    change_column :instagram_slides, :url, :text, :limit => 65000, :null => true, :default => nil
    change_column :instagram_slides, :video_url, :text, :limit => 65000, :null => true, :default => nil
  end
end
