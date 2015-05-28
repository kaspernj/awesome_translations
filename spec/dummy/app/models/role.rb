class Role < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :role

  def self.roles
    return {
      t(".administrator") => "admin",
      t(".moderator") => "moderator"
    }
  end

  def self.roles_array
    [[t('.user'), 'user']]
  end
end
