class AddPositionToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :position, :string
  end

  def self.down
    remove_column :people, :position
  end
end
