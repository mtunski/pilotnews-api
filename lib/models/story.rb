class Story < ActiveRecord::Base
  belongs_to :poster, class_name: 'User'
  has_many :votes
  has_many :voters, through: :votes, source: :user

  validates :title, :url, presence: true
end
