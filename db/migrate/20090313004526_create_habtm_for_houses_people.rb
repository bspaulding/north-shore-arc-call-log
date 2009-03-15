class CreateHabtmForHousesPeople < ActiveRecord::Migration
  def self.up
  	create_table :houses_people do |t|
  	  t.integer :house_id
  	  t.integer :person_id
  	end
  end

  def self.down
  	drop_table :houses_people
  end
end
