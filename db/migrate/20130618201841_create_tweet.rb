class CreateTweet < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer  :followers
      t.string   :remote_id
      t.string   :message
      t.float    :sentiment
      t.string   :user_handle
      t.datetime :remote_created_at
      t.datetime :remote_updated_at
    end

    add_index :tweets, :remote_id, unique: true
  end
end
