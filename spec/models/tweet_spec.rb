require 'spec_helper'

describe Tweet do
  describe 'validations' do
    it { should validate_presence_of(:remote_id) }
    it { should validate_uniqueness_of(:remote_id) }
    it { should validate_presence_of(:remote_created_at) }
    it { should validate_presence_of(:remote_updated_at) }
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:sentiment) }
    it { should validate_numericality_of(:sentiment).is_greater_than_or_equal_to(-1.0).is_less_than_or_equal_to(1.0) }
    it { should validate_presence_of(:user_handle) }
    it { should validate_presence_of(:followers) }
    it { should validate_numericality_of(:followers).only_integer.is_greater_than_or_equal_to(0) }
  end
end