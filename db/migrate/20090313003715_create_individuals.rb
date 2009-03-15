class CreateIndividuals < ActiveRecord::Migration
  def self.up
    create_table :individuals do |t|
	  t.string :name
	  t.string :guardian_name
	  t.string :guardian_phone_home
	  t.string :guardian_phone_work
	  t.string :guardian_phone_mobile
	  t.string :pcp
	  t.string :pcp_phone_number
	  t.string :day_program
	  t.string :day_program_phone
	  t.string :transportation
	  t.string :transportation_phone
      t.timestamps
    end
  end

  def self.down
    drop_table :individuals
  end
end
