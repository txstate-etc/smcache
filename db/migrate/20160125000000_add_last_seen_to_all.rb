class AddLastSeenToAll < ActiveRecord::Migration
  def change
    add_column :tweets, :last_seen, :datetime
    add_column :instagram_posts, :last_seen, :datetime
    add_column :facebook_posts, :last_seen, :datetime

    add_index :tweets, [:last_seen, :tweettime]
    add_index :tweets, [:last_seen, :tweettime, :favorite]

    add_index :instagram_posts, [:last_seen, :posttime]
    add_index :facebook_posts, [:last_seen, :posttime]
  end
end
