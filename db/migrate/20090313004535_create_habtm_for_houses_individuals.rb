class CreateHabtmForHousesIndividuals < ActiveRecord::Migration
  def self.up
  	create_table :houses_individuals do |t|
  	  t.integer :house_id
  	  t.integer :individual_id
  	end
  end

  def self.down
    drop_table :houses_individuals
  end
end
