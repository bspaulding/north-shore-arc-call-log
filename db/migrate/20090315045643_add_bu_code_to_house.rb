class AddBuCodeToHouse < ActiveRecord::Migration
  def self.up
    add_column :houses, :bu_code, :string
  end

  def self.down
    remove_column :houses, :bu_code
  end
end
