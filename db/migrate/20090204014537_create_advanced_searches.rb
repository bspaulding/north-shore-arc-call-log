class CreateAdvancedSearches < ActiveRecord::Migration
  def self.up
    create_table :advanced_searches do |t|
      t.string :first_name
      t.string :last_name
      t.string :nickname
      t.string :email
      t.string :home_phone
      t.string :mobile_phone
      t.string :address_street
      t.string :address_city
      t.string :address_state
      t.string :address_zip
      t.date :hired_before
      t.date :hired_after

      t.timestamps
    end
    
    create_table :advanced_searches_certifications do |t|
      t.integer :advanced_search_id
      t.integer :certification_id
    end
  end

  def self.down
    drop_table :advanced_searches
    drop_table :advanced_searches_certifications
  end
end
