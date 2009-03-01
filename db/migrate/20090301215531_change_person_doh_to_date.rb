class ChangePersonDohToDate < ActiveRecord::Migration
  def self.up
    change_column :people, :doh, :date
  end

  def self.down
    change_column :people, :doh, :datetime
  end
end
