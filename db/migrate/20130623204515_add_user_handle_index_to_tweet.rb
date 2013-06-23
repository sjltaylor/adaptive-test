class AddUserHandleIndexToTweet < ActiveRecord::Migration
  def change
    add_index :tweets, :user_handle
  end
end
