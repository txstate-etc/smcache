class CreateTwitterRateLimits < ActiveRecord::Migration
  def change
    create_table :twitter_rate_limits do |t|
      t.string :endpoint
      t.integer :limit
      t.integer :remaining
      t.datetime :reset_at
      t.integer :reset_in

      t.timestamps null: false
    end
    add_index :twitter_rate_limits, :endpoint, unique: true
  end
end
