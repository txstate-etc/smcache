class AddSlidesToFacebook < ActiveRecord::Migration
  def change
    create_table :facebook_slides do |t|
      t.integer :facebook_post_id, :null => false, :default => 0
      t.string :url, :null => false, :default => ''
      t.string :mediatype, :null => false, :default => ''
      t.integer :width, :null => false, :default => 0
      t.integer :height, :null => false, :default => 0
      t.index [:facebook_post_id,:url], unique: true
    end
  end
end
