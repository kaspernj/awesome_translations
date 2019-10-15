class User < ApplicationRecord
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, length: {in: 2..255}, format: {with: /\A.+@.+\Z/}
  validates :email, confirmation: true

  has_many :roles, dependent: :destroy
end
