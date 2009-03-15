class AddBehaviorPlansToHouse < ActiveRecord::Migration
  def self.up
    add_column :houses, :behavior_plans, :text
  end

  def self.down
    remove_column :houses, :behavior_plans
  end
end
