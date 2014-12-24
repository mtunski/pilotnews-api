class User < ActiveRecord::Base
  validates :login,    presence: true
  validates :password, length: { minimum: 3 }
end
