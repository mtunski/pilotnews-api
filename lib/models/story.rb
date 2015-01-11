class Story < ActiveRecord::Base
  belongs_to :poster, class_name: 'User'
  has_many :votes
  has_many :voters, through: :votes, source: :user

  validates :title, :url, :poster, presence: true

  def attributes
    super.merge(score: score)
  end

  def score
    votes.sum(:value)
  end
end
