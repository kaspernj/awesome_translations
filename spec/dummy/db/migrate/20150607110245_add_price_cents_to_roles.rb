class AddPriceCentsToRoles < ActiveRecord::Migration[5.1]
  def change
    add_column :roles, :price_cents, :integer
  end
end
