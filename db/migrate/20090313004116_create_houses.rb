class CreateHouses < ActiveRecord::Migration
  def self.up
    create_table :houses do |t|
      t.text :agency_staff
      t.text :overview
      t.text :ratio
      t.text :trainings_needed
      t.text :medication_times
      t.text :waivers
      t.text :keys
      t.text :schedule_info
      t.text :phone_numbers
      
      t.string :name
      t.string :address_street
      t.string :address_city
      t.string :address_state
      t.string :address_zip
      t.string :phone_1
      t.string :phone_2
      t.string :fax
      
      t.timestamps
    end
  end

  def self.down
    drop_table :houses
  end
end
