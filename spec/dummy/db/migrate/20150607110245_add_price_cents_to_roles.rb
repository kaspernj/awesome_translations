class AddPriceCentsToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :price_cents, :integer
  end
end
