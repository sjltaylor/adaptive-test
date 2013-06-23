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
    it { should have_db_index(:remote_id) }
    it { should validate_presence_of(:times_seen) }
    it { should have_db_column(:times_seen).with_options(default: 0) }
    it { should validate_numericality_of(:times_seen).only_integer.is_greater_than_or_equal_to(1) }
  end

  describe '#mentions_coke?' do
    let(:tweet) { Tweet.new }

    describe 'when the tweet did not mention coke' do
      it 'returns false' do
        tweet.message = 'pepsi is not as good'
        tweet.mentions_coke?.should be_false
      end
    end

    context "tweets that mention coke" do
      [
        "I like Coke alot",
        "coke is great",
        "diet cola is not as good",
        "get me a diet Cola",
        "coca-cola is very nice",
        "my mum does not like COCA-COLA"
      ].each do |coke_related_message|
        it "returns true that '#{coke_related_message}' mentioned coke" do
          tweet.message = coke_related_message
        tweet.mentions_coke?.should be_true
        end
      end
    end
  end
end