class Tweet < ApplicationRecord
  belongs_to :user
  has_many :tweet_tags
  has_many :tags, through: :tweet_tags
  #validations
  validates :message, presence: true
  validates :message, length: { maximum: 280, too_long: "A tweet is only 280 max character. Revise and try again!"}

  #hooks
  before_validation :link_check, on: :create
  after_validation :apply_link, on: :create

  scope :trending, -> { joins(:tags).group('tags.id').order('count(*) desc').limit(3) }

  private

  def apply_link
    arr = self.message.split
    index = arr.map { |x| x.include? 'http' }.index{true}

    if index
      shortened_url = arr[index]
      arr[index] = "<a href=#{self.link}' target='_blank'>#{shortened_url}</a>"
    end
      self.message = arr.join(' ')
  end

  def link_check

    if self.message.include?('http://') || self.message.include?('https://')
      arr = self.message.split
      index = arr.map { |x| x.include? 'http' }.index(true)
      self.link = arr[index]
      if self.link.length > 23
        arr[index] = "#{arr[index][0..19]}..."
      end
      self.message = arr.join(' ')
    end
  end
end
