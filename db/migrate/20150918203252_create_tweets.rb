class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweetid
      t.datetime :tweettime
      t.binary :text
      t.string :screen_name
      t.binary :display_name
      t.text :profile_image
      t.boolean :favorite

      t.timestamps null: false
    end
    add_index :tweets, :tweetid, unique: true
    add_index :tweets, :tweettime
    add_index :tweets, [:tweettime, :favorite], name: "tweets_time_fav"
  end
end
