namespace :setup do
	task :development => [:environment, "db:migrate"] do 
		# Clear the database of all models.
		puts "\nClearing the database of all models...\n"
		AdvancedSearch.destroy_all
		Certification.destroy_all
		DatabaseUpdate.destroy_all
		House.destroy_all
		Individual.destroy_all
		Person.destroy_all
		PersonsCertification.destroy_all
		Right.destroy_all
		Role.destroy_all		
		
		# Set default authorization roles/rights NOTE: Include DB_UPDATE_CREATE in administrator
		puts "\nSetting up default authorization levels..."
		# DirectCareProvider
		puts "\t* DirectCareProvider:"
		role_direct_care = Role.create!(:name => "DirectCareProvider")
		# 	people/show
		puts "\t\t- people/show"
		profiles = Right.create!(:name => "User Profiles", :controller => "people", :action => "show")
		role_direct_care.rights << profiles
		
		# Supervisor
		puts "\t* Supervisor:"
		role_supervisor = Role.create!(:name => "Supervisor")
		# 	supervisor/all
		puts "\t\t- supervisor/all"
		super_home = Right.create!(				:name => "Supervisor Controller (all)",
																			:controller => "supervisor")
		role_supervisor.rights << super_home
		# 	houses/all
		puts "\t\t- houses/all"
		houses_all = Right.create!(				:name => "Houses (all)",
																			:controller => "houses")
		role_supervisor.rights << houses_all
		# 	advanced_searches/all
		puts "\t\t- advanced_searches/all"
		adv_searches_all = Right.create!(	:name => "AdvancedSearches (all)",
																			:controller => "advanced_searches")
		role_supervisor.rights << adv_searches_all
		# 	database_updates/show
		puts "\t\t- database_updates/show"
		dbups_show = Right.create!(				:name => "DatabaseUpdates (show)",
																			:controller => "database_updates",
																			:action => "show")
		role_supervisor.rights << dbups_show
		# 	people/all
		puts "\t\t- people/all"
		people_all = Right.create!(				:name => "People (all)",
																			:controller => "people")
		role_supervisor.rights << people_all
	
		# Administrator
		puts "\t* Administrator:"
		role_administrator = Role.create!(:name => "Administrator")
		puts "\t\t- all/all"
		all_access = Right.create!(	:name => "All Access")
		role_administrator.rights << all_access
	
		# Create default people for each role
		puts "\nCreating default users for each role: (email/pass)"
		puts "\t* directcareprovider@nsarc.org/password"
		dcp = Person.create!(:first_name => "DirectCareProvider", :email_address => "directcareprovider@nsarc.org", :password => "password")
		dcp.roles << role_direct_care
		puts "\t* supervisor@nsarc.org/password"
		supervisor = Person.create!(:first_name => "Supervisor", :email_address => "supervisor@nsarc.org", :password => "password")
		supervisor.roles << [role_direct_care, role_supervisor]
		puts "\t* administrator@nsarc.org/password"
		admin = Person.create!(:first_name => "Administrator", :email_address => "administrator@nsarc.org", :password => "password")
		admin.roles << [role_direct_care, role_supervisor, role_administrator]
		
		# Generate Random people, with certifications and expiration dates and positions
		require 'populator'
    require 'faker'
    
    puts "\nGenerating certifications..."
    cert_fa = Certification.create!(:name => 'First Aid')
		cert_mt = Certification.create!(:name => 'Med Training')
		cert_cpr = Certification.create!(:name => 'CPR')
    
    positions = [	"House Director", "Asst. Div. Director", "Clinical Manager", "Asst. House Director",
									"House Manager", "Awake Overnight", "Relief", "Heritage Specialty", "Middleton 4" ]
    
    puts "\nGenerating random people..."
    # - Create 50...100 people
    Person.populate 300...500 do |person|
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
      person.position				= positions
      person.bu_code				= "299"
    end
		
		puts "\nAdding certifications with expiration dates, and default roles to people..."
		# - Add certification info and assign roles randomly to every person
		date_range_array = (1.years.from_now.to_date..Date.today).to_a
		Person.all.each do |person|
			# cert info
			person.certifications << [cert_fa, cert_mt, cert_cpr]
      person.persons_certifications.each do |pc|
      	pc.expiration_date = date_range_array[rand(date_range_array.size)]
      	pc.save!
      end
      
      # roles
      person.roles << role_direct_care
      if (rand(10) > 7)
      	person.roles << role_supervisor
      end
      person.save!
		end
		
		puts "\nGenerating default houses..."
		# Create default Houses
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
		
		puts "\nAll Done!"
	end
	
	task :production => [:environment, "db:migrate"] do 
		# Clear the database of all models
		
		# Set default authorization roles/rights
		
		# Add default admin user
	end
end