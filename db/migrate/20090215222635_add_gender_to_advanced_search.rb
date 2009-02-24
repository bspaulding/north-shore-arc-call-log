class AddGenderToAdvancedSearch < ActiveRecord::Migration
  def self.up
    add_column :advanced_searches, :gender, :string
  end

  def self.down
    remove_column :advanced_searches, :gender
  end
end
