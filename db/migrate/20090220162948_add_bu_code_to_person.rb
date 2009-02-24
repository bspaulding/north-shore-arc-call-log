class AddBuCodeToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :bu_code, :integer
  end

  def self.down
    remove_column :people, :bu_code
  end
end
