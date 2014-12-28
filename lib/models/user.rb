require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  validates :login,    presence:   true,
                       uniqueness: true
  validates :password, length: { minimum: 3 }, on: :create

  def password
    @password ||= Password.new(encrypted_password)
  end

  def password=(new_password)
    @password               = Password.create(new_password)
    self.encrypted_password = password
  end
end
