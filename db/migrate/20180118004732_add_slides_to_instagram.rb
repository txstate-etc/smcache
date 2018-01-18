class AddSlidesToInstagram < ActiveRecord::Migration
  def change
    create_table :instagram_slides do |t|
      t.integer :instagram_post_id, :null => false, :default => 0
      t.string :url, :null => false, :default => ''
      t.string :mediatype, :null => false, :default => ''
      t.integer :width, :null => false, :default => 0
      t.integer :height, :null => false, :default => 0
      t.string :video_url, :null => false, :default => ''
      t.index :url, unique: true
    end
  end
end
