class User
  include Mongoid::Document
  field :username, type: String
  field :email, type: String
  field :password_digest, type: String

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates :password_digest, presence: true, length: {minimum: 6}, on: :add_user
end
