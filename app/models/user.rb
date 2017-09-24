
require 'bcrypt'
require 'dm-validations'

class User
  include DataMapper::Resource
  attr_reader :password, :name
  attr_accessor :password_confirmation

  validates_confirmation_of :password

  property :id, Serial
  property :email, String
  property :name, String
  property :password_digest, Text

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(name, password)
    user = first(name: name)

    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end
end
