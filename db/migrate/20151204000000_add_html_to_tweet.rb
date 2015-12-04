class AddHtmlToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :html, :binary
  end
end
