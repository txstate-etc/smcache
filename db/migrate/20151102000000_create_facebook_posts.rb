class CreateFacebookPosts < ActiveRecord::Migration
  def change
    create_table :facebook_posts do |t|
      t.string :postid, null: false
      t.datetime :posttime, null: false
      t.binary :caption
      t.text :url
      t.integer :width
      t.integer :height
      t.string :mediatype
      t.text :video_url
      t.integer :video_width
      t.integer :video_height

      t.timestamps null: false
    end
    add_index :facebook_posts, :postid, unique: true
    add_index :facebook_posts, :posttime
  end
end
