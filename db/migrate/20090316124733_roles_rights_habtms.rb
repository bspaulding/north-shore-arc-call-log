class RolesRightsHabtms < ActiveRecord::Migration
  def self.up
		create_table :rights_roles, :id => false do |t|
			t.integer :right_id
			t.integer :role_id
		end
		
		create_table :people_roles, :id => false do |t|
			t.integer :person_id
			t.integer :role_id
		end
  end

  def self.down
  	drop_table :rights_roles
  	drop_table :people_roles
  end
end
