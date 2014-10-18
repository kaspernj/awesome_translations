class Role < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :role
end
