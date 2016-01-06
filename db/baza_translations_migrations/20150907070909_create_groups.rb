class CreateGroups < BazaMigrations::Migration
  def change
    create_table :groups do |t|
      t.belongs_to :handler
      t.string :identifier
      t.string :name
      t.timestamps
    end

    add_index :groups, :identifier
    add_index :groups, :handler_id
  end
end
