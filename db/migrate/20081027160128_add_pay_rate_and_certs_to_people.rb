class AddPayRateAndCertsToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :pay_rate_dollars, :integer
    add_column :people, :pay_rate_cents, :integer
    
    create_table :certifications do |t|
      t.string :name
      t.string :short_name
      
      t.timestamps
    end
    
    create_table :persons_certifications do |t|
      t.integer :certification_id
      t.integer :person_id
      t.timestamp :expiration_date
      t.timestamps
    end
  end

  def self.down
    remove_column :people, :pay_rate_dollars
    remove_column :people, :pay_rate_cents
    drop_table :certifications
    drop_table :persons_certifications
  end
end
