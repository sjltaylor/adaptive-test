module LandingHelper
  def message_class(tweet)
    tweet.mentions_coke? ? 'about-coke' : 'not-about-coke'
  end
end
