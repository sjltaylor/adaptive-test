class Tweet < ActiveRecord::Base
  validates :remote_id,         presence: true, uniqueness: true
  validates :remote_created_at, presence: true
  validates :remote_updated_at, presence: true
  validates :message,           presence: true
  validates :user_handle,       presence: true
  validates :sentiment,         presence: true, numericality: { greater_than_or_equal_to: -1.0, less_than_or_equal_to: 1.0 }
  validates :followers,         presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :times_seen,        presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end