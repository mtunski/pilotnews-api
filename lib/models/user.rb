require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  attr_accessor :password

  has_many :stories, foreign_key: :poster_id
  has_many :votes

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
