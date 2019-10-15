class Role < ApplicationRecord
  translates :name

  belongs_to :user

  validates :user, :role, presence: true

  monetize :price_cents, allow_nil: true

  def self.roles
    {
      t(".administrator") => "admin",
      t(".moderator") => "moderator"
    }
  end

  def self.roles_array
    [[t(".user"), "user"]]
  end
end
