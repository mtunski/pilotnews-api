class Vote < ActiveRecord::Base
  belongs_to :story
  belongs_to :user

  validates :story, :user, presence: true
  validates :value, inclusion: { in: [-1, 1],
                                 message: 'Value can be either -1 (downvote) or 1 (upvote)' }
end
