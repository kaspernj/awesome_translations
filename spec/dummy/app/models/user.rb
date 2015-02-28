class User < ActiveRecord::Base
  validates_presence_of :email
  validates_uniqueness_of :email
  validates :email, length: {in: 2..255}, format: {with: /\A[A-z]+\Z/}

  has_many :roles, dependent: :destroy
end
