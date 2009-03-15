namespace :db do 
	task :populate_house_fields => :environment do
		House.all.each do |house|
			# t.text     "agency_staff"
			if house.agency_staff.nil?
				house.agency_staff = House::DEFAULT_FIELD_TEXT
			end
			
	    # t.text     "overview"
	    if house.overview.nil?
				house.overview = House::DEFAULT_FIELD_TEXT
			end
			
	    # t.text     "ratio"
	    if house.ratio.nil?
				house.ratio = House::DEFAULT_FIELD_TEXT
			end
			
	    # t.text     "trainings_needed"
	    if house.trainings_needed.nil?
				house.trainings_needed = House::DEFAULT_FIELD_TEXT
			end
			
	    # t.text     "medication_times"
	    if house.medication_times.nil?
				house.medication_times = House::DEFAULT_FIELD_TEXT
			end
			
			# t.text     "waivers"
	    if house.waivers.nil?
				house.waivers = House::DEFAULT_FIELD_TEXT
			end
			
			# t.text     "keys"
	    if house.keys.nil?
				house.keys = House::DEFAULT_FIELD_TEXT
			end
			
			# t.text     "schedule_info"
	    if house.schedule_info.nil?
				house.schedule_info = House::DEFAULT_FIELD_TEXT
			end
			
			# t.text     "phone_numbers"
	    if house.phone_numbers.nil?
				house.phone_numbers = House::DEFAULT_FIELD_TEXT
			end
			
			# t.string   "address_street"
	    if house.address_street.nil?
				house.address_street = House::DEFAULT_ADDRESS_STREET
			end
			
			# t.string   "address_city"
	    if house.address_city.nil?
				house.address_city = House::DEFAULT_ADDRESS_CITY
			end
			
			# t.string   "address_state"
	    if house.address_state.nil?
				house.address_state = House::DEFAULT_ADDRESS_STATE
			end
			
			# t.string   "address_zip"
	    if house.address_zip.nil?
				house.address_zip = House::DEFAULT_ADDRESS_ZIP
			end
			
			# t.string   "phone_1"
	    if house.phone_1.nil?
				house.phone_1 = House::DEFAULT_PHONE_1
			end
			
			# t.string   "phone_2"
	    if house.phone_2.nil?
				house.phone_2 = House::DEFAULT_PHONE_2
			end
			
			# t.string   "fax"
			if house.fax.nil?
				house.fax = House::DEFAULT_FAX
			end
			
			house.save!
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
	
  task :populate => :environment do 
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