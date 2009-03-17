class AddImageToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :image, :string
  end

  def self.down
    remove_column :people, :image
  end
end
