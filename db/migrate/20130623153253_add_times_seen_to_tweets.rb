class AddTimesSeenToTweets < ActiveRecord::Migration
  def up
    add_column :tweets, :times_seen, :integer, default: 0
    Tweet.reset_column_information
    Tweet.update_all(times_seen: 1)
  end

  def down
    remove_column :tweets, :times_seen
  end
end
