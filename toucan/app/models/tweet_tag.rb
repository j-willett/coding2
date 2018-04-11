class TweetTag < ApplicationRecord
  #associations
  belongs_to :tweet
  belongs_to :tag
end
