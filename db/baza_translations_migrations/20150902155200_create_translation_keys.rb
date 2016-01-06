class CreateTranslationKeys < BazaMigrations::Migration
  def change
    create_table :translation_keys do |t|
      t.belongs_to :handler
      t.belongs_to :group
      t.string :key
      t.timestamps
    end

    add_index :translation_keys, :key
    add_index :translation_keys, :group_id
    add_index :translation_keys, :handler_id
  end
end
