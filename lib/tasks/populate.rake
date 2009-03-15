namespace :db do 
	task :populate_houses => :environment do
		House.destroy_all
		House::DEFAULT_HOUSES_AND_CODES.each do |house_and_code|
			House.create!(:name => house_and_code[0],
										:bu_code => house_and_code[1],
										:agency_staff => House::DEFAULT_FIELD_TEXT,
										:overview => House::DEFAULT_FIELD_TEXT,
										:ratio => House::DEFAULT_FIELD_TEXT,
										:trainings_needed => House::DEFAULT_FIELD_TEXT,
										:medication_times => House::DEFAULT_FIELD_TEXT,
										:waivers => House::DEFAULT_FIELD_TEXT,
										:keys => House::DEFAULT_FIELD_TEXT,
										:schedule_info => House::DEFAULT_FIELD_TEXT,
										:behavior_plans => House::DEFAULT_FIELD_TEXT,
										:phone_numbers => House::DEFAULT_FIELD_TEXT,
										:address_street => House::DEFAULT_ADDRESS_STREET,
										:address_city => House::DEFAULT_ADDRESS_CITY,
										:address_state => House::DEFAULT_ADDRESS_STATE,
										:address_zip => House::DEFAULT_ADDRESS_ZIP,
										:phone_1 => House::DEFAULT_PHONE_1,
										:phone_2 => House::DEFAULT_PHONE_2,
										:fax => House::DEFAULT_FAX)
		end
	end
		
	task :populate_positions => :environment do
		positions = [	"House Director", "Asst. Div. Director", "Clinical Manager", "Asst. House Director",
									"House Manager", "Awake Overnight", "Relief", "Heritage Specialty", "Middleton 4"]
		@people = Person.all
		@people.each do |person|
			person.position = positions[(rand*positions.size).to_i]
			person.save!
		end
	end
	
  task :populate_with_fake_people => :environment do 
    require 'populator'
    require 'faker'
    
    Person.destroy_all
    PersonsCertification.destroy_all
    Certification.destroy_all
    
    @fa = Certification.create(:name => 'First Aid')
    @fa.save!
    
    DirectCareProvider.populate 50...100 do |person|
      fs = Faker::Name.first_name
      person.first_name     = fs
      person.last_name      = Faker::Name.last_name
      person.nickname       = fs
      person.email_address  = Faker::Internet.email
      person.gender         = ['male', 'female']
      person.home_phone     = Faker::PhoneNumber.phone_number
      person.mobile_phone   = Faker::PhoneNumber.phone_number
      person.doh            = 20.years.ago...Time.now 
      person.address_street = Faker::Address.street_address
      person.address_city   = Faker::Address.city
      person.address_state  = Faker::Address.us_state_abbr
      person.address_zip    = Faker::Address.zip_code
    end
    
    Supervisor.populate 50...100 do |person|
      fs = Faker::Name.first_name
      person.first_name     = fs
      person.last_name      = Faker::Name.last_name
      person.nickname       = fs
      person.email_address  = Faker::Internet.email
      person.gender         = ['male', 'female']
      person.home_phone     = Faker::PhoneNumber.phone_number
      person.mobile_phone   = Faker::PhoneNumber.phone_number
      person.doh            = 20.years.ago...Time.now 
      person.address_street = Faker::Address.street_address
      person.address_city   = Faker::Address.city
      person.address_state  = Faker::Address.us_state_abbr
      person.address_zip    = Faker::Address.zip_code
    end
    
    Person.all.each do |person|
      person.certifications << @fa
      pc = person.persons_certifications.first
      pc.expiration_date = Date.today
      pc.save!
    end
  end
end