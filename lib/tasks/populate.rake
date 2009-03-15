namespace :db do 
	task :populate_houses => :environment do
		houses_and_codes = [["Avalon", "229"],
												["Beverly House", "201"], 
												["Burlington", "204"],
												["Cape Ann Women's", "233"], 
												["Cape Ann Community Residence", "202"], 
												["Charlie Deleo", "282"],
												["Clifton Avenue", "243"], 
												["Collins Street", "272"], 
												["D/S Men's Coop", "252"],
												["D/S Women's Coop", "253"], 
												["Gloucester/Beverly Coop", "251"], 
												["Gloucester Men's Apartment", "232"],
												["Hale Street Elders Apartment", "273"], 
												["Individual Retirement Program", "410"], 
												["Intervale", "234"],
												["Lafayette Street", "244"], 
												["Linden Street", "242"], 
												["Mason Street", "231"],
												["Middleton 6", "271"], 
												["Middleton 4", "270"], 
												["Peabody House", "241"],
												["Princeton Street", "261"], 
												["Lynn Deaf Program", "228"], 
												["Relief Specialist", "41650-130"],
												["Rogers Road", "269"], 
												["Ryan Place", "226"], 
												["STL", "274"],
												["Swampscott Women's Apartment", "227"], 
												["Teresa Bettencourt", "292"], 
												["Martita Means", "275"],
												["Debbie Goos", "276"], 
												["Washington Street", "277"], 
												["Briana", "278"],
												["Independent", ""]]
		House.destroy_all
		houses_and_codes.each do |house_and_code|
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
	
	task :populate_house_fields => :environment do
		House.all.each do |house|
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