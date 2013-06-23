require 'spec_helper'

describe LandingHelper do
  include LandingHelper

  describe '#message_class' do
    describe 'when the tweet mentions coke' do
      it 'returns "about-coke"' do
        message_class(stub(:tweet, :mentions_coke? => true)).should == 'about-coke'
      end
    end
    describe 'when the tweet does not mention coke' do
      it 'returns "not-about-coke"' do
        message_class(stub(:tweet, :mentions_coke? => false)).should == 'not-about-coke'
      end
    end
  end
end