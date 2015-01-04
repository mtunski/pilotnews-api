require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  attr_accessor :password

  validates :login,    presence:   true,
                       uniqueness: true
  validates :password, length: { minimum: 3 }, on: :create

  before_create :encrypt_password

  def password
    @password ||= Password.new(encrypted_password)
  end

  private

  def encrypt_password
    @password = self.encrypted_password = Password.create(password)
  end
end
