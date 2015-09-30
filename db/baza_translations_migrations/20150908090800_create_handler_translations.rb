class CreateHandlerTranslations < BazaMigrations::Migration
  def change
    create_table :handler_translations do |t|
      t.belongs_to :handler
      t.belongs_to :translation_key
      t.belongs_to :group
      t.string :key_show
      t.string :file_path
      t.integer :line_no
      t.string :full_path
      t.string :dir
      t.string :default
      t.timestamps
    end

    add_index :handler_translations, :handler_id
    add_index :handler_translations, :translation_key_id
    add_index :handler_translations, :group_id
    add_index :handler_translations, :file_path
  end
end
