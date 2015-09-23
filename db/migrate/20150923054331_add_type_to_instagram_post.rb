class AddTypeToInstagramPost < ActiveRecord::Migration
  def change
    add_column :instagram_posts, :mediatype, :string
  end
end
