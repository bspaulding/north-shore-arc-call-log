class CreateDatabaseUpdates < ActiveRecord::Migration
  def self.up
    create_table :database_updates do |t|
      t.string :spreadsheet_path
      t.text :changes

      t.timestamps
    end
  end

  def self.down
    drop_table :database_updates
  end
end
