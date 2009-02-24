class AddHridToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :hrid, :integer
  end

  def self.down
    remove_column :people, :hrid
  end
end
