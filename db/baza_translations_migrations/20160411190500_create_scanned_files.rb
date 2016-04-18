class CreateScannedFiles < BazaMigrations::Migration
  def change
    create_table :scanned_files do |t|
      t.string :file_path
      t.integer :file_size
      t.datetime :last_changed_at
      t.timestamps
    end
  end
end
