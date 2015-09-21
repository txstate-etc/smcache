class CreateInstagramPosts < ActiveRecord::Migration
  def change
    create_table :instagram_posts do |t|
      t.string :postid, null: false
      t.datetime :posttime, null: false
      t.binary :caption
      t.text :url
      t.integer :width
      t.integer :height

      t.timestamps null: false
    end
    add_index :instagram_posts, :postid, unique: true
    add_index :instagram_posts, :posttime
  end
end
