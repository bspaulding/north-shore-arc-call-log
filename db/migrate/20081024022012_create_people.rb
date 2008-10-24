class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :type
      t.string :first_name
      t.string :last_name
      t.string :nickname
      t.string :home_phone
      t.string :mobile_phone
      t.string :email_address
      t.string :gender
      t.string :address_street
      t.string :address_city
      t.string :address_state
      t.string :address_zip
      t.timestamp :doh

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
