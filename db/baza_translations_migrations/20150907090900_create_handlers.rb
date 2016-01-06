class CreateHandlers < BazaMigrations::Migration
  def change
    create_table :handlers do |t|
      t.string :identifier
      t.string :name
      t.timestamps
    end

    add_index :handlers, :identifier
  end
end
