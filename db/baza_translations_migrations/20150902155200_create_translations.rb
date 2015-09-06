class CreateTranslations < BazaMigrations::Migration
  def change
    create_table :translations do |t|
      t.string :locale
      t.string :key
      t.string :handler
      t.string :group
      t.string :file_path_yml
      t.string :file_path_translation
      t.integer :line_no
      t.string :value_yml
      t.string :value_translation
      t.string :default
      t.timestamps
    end

    add_index :translations, :file_path
    add_index :translations, :key
  end
end
