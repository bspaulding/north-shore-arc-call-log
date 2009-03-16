class AddUpdateTypeToDatabaseUpdate < ActiveRecord::Migration
  def self.up
    add_column :database_updates, :update_type, :string
  end

  def self.down
    remove_column :database_updates, :update_type
  end
end
