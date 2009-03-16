class AddPasswordSaltAndPasswordHashToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :password_salt, :string
    add_column :people, :password_hash, :string
  end

  def self.down
    remove_column :people, :password_hash
    remove_column :people, :password_salt
  end
end
