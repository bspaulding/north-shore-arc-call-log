class FixSearchesCertsHabtmTable < ActiveRecord::Migration
  def self.up
  	drop_table :advanced_searches_certifications 
  	create_table :advanced_searches_certifications, :id => false do |t|
  		t.integer :advanced_search_id
  		t.integer :certification_id
  	end
  end

  def self.down
	  drop_table :advanced_searches_certifications 
  	create_table :advanced_searches_certifications do |t|
  		t.integer :advanced_search_id
  		t.integer :certification_id
  	end
  end
end
