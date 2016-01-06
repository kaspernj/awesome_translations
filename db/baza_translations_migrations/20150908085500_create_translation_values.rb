class CreateTranslationValues < BazaMigrations::Migration
  def change
    create_table :translation_values do |t|
      t.belongs_to :translation_key
      t.string :file_path
      t.string :locale
      t.string :value
      t.timestamps
    end

    add_index :translation_values, :translation_key_id
    add_index :translation_values, :locale
  end
end
