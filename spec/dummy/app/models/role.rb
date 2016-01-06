class Role < ActiveRecord::Base
  translates :name

  belongs_to :user

  validates_presence_of :user, :role

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
