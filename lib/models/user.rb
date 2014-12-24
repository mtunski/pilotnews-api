class User < ActiveRecord::Base
  validates :login,    presence: true,
                       uniqueness: true
  validates :password, length: { minimum: 3 }
end
