# = House
#
# === Purpose
# Encapsulates a House.
#
# === Associations
# - has_and_belongs_to_many :people[link:Person.html], :order => "last_name,first_name ASC"
#	- has_and_belongs_to_many :individuals[link:Individual.html]
#
class House < ActiveRecord::Base
	# Constants
	DEFAULT_FIELD_TEXT = "This section currently has no information. Please enter the appropriate information here by clicking on this text."
	DEFAULT_ADDRESS_STREET = "Click To Add A Street Address"
	DEFAULT_ADDRESS_CITY = "Click To Add A City"
	DEFAULT_ADDRESS_STATE = "Click To Add A State"
	DEFAULT_ADDRESS_ZIP = "Click To Add A Zip Code"
	DEFAULT_PHONE_1 = "Click To Add Phone #1"
	DEFAULT_PHONE_2 = "Click To Add Phone #2"
	DEFAULT_FAX = "Click To Add A Fax Number"
	DEFAULT_BU_CODE = "Click to Set BU_CODE"
	
	DEFAULT_HOUSES_AND_CODES = [["Avalon", "229"],
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
	
	# Hooks
	before_create :set_defaults
	
	# Called before create, set_defaults sets blank fields to their default values.
	def set_defaults
		self.agency_staff			= DEFAULT_FIELD_TEXT			if agency_staff.nil?
		self.overview 				= DEFAULT_FIELD_TEXT		 	if overview.nil?
		self.ratio 						= DEFAULT_FIELD_TEXT		 	if ratio.nil?
		self.trainings_needed = DEFAULT_FIELD_TEXT		 	if trainings_needed.nil?
		self.medication_times = DEFAULT_FIELD_TEXT		 	if medication_times.nil?
		self.waivers 					= DEFAULT_FIELD_TEXT		 	if waivers.nil?
		self.keys 						= DEFAULT_FIELD_TEXT		 	if keys.nil?
		self.schedule_info 		= DEFAULT_FIELD_TEXT 			if schedule_info.nil?
		self.phone_numbers 		= DEFAULT_FIELD_TEXT 			if phone_numbers.nil?
		self.behavior_plans 	= DEFAULT_FIELD_TEXT 			if behavior_plans.nil?
		self.name							= "Untitled"				 			if name.nil?
    self.address_street		= DEFAULT_ADDRESS_STREET 	if address_street.nil?
    self.address_city			= DEFAULT_ADDRESS_CITY 		if address_city.nil?
    self.address_state		= DEFAULT_ADDRESS_STATE 	if address_state.nil?
    self.address_zip			= DEFAULT_ADDRESS_ZIP 		if address_zip.nil?
    self.phone_1					= DEFAULT_PHONE_1 				if phone_1.nil?
    self.phone_2					= DEFAULT_PHONE_2 				if phone_2.nil?
    self.fax							= DEFAULT_FAX 						if fax.nil?
    self.bu_code					= DEFAULT_BU_CODE		 			if bu_code.nil?
	end
	
	# Associations:
	has_and_belongs_to_many :people, :order => "last_name,first_name ASC"
	has_and_belongs_to_many :individuals
	
	# Categorized People Accessors
	#	Positions
	# - House Director
	# - Asst. Div. Director
	# - Clinical Manager
	# - Asst. House Director
	# - House Manager
	# - Awake Overnight
	# - Relief
	# - Heritage Specialty
	# - Middleton 4
	
	# Returns the combined results of house_directors, asst_div_directors, clinical_managers and asst_house_managers
	def all_directors
		self.house_directors + self.asst_div_directors + self.clinical_managers + self.asst_house_managers
	end
	
	# Returns an array of people whose job title is 'House Director' and who are associated with this house.
	def house_directors
		Person.find(:all, 
								:conditions => "people.position = 'House Director' AND house_id = #{self.id}", 
								:joins => :houses, 
								:order => "last_name, first_name ASC")
	end
	
	# Returns an array of people whose job title is 'Asst. Div. Director' and who are associated with this house.
	def asst_div_directors
		Person.find(:all, 
								:conditions => "people.position = 'Asst. Div. Director' AND house_id = #{self.id}", 
								:joins => :houses, 
								:order => "last_name, first_name ASC")
	end
	
	# Returns an array of people whose job title is 'Clinical Manager' and who are associated with this house.
	def clinical_managers
		Person.find(:all, 
								:conditions => "people.position = 'Clinical Manager' AND house_id = #{self.id}", 
								:joins => :houses, 
								:order => "last_name, first_name ASC")
	end
	
	# Returns an array of people whose job title is 'Asst. House Director' and who are associated with this house.
	def asst_house_managers
		Person.find(:all, 
								:conditions => "people.position = 'Asst. House Director' AND house_id = #{self.id}", 
								:joins => :houses, 
								:order => "last_name, first_name ASC")
	end
	
	# Returns an array of people whose job title is 'House Manager' and who are associated with this house.
	def house_managers
		Person.find(:all, 
								:conditions => "people.position = 'House Manager' AND house_id = #{self.id}", 
								:joins => :houses, 
								:order => "last_name, first_name ASC")
	end
	
	# Returns an array of people whose job title is 'Awake Overnight' and who are associated with this house.
	def awake_overnights
		Person.find(:all,
								:conditions => "people.position = 'Awake Overnight' AND house_id = #{self.id}", 
								:joins => :houses, 
								:order => "last_name, first_name ASC")
	end
	
	# Returns an array of people whose job title is 'Relief' and who are associated with this house.
	def relief_staff
		Person.find(:all,
								:conditions => "people.position = 'Relief' AND house_id = #{self.id}",
								:joins => :houses,
								:order => "last_name, first_name ASC")
	end
	
	# Returns an array of people whose job title is 'Heritage Specialty' or 'Middleton 4' and who are associated with this house.
	def overtime_staff
		Person.find(:all, 
								:conditions => "people.position = 'Heritage Specialty' AND house_id = #{self.id} OR people.position = 'Middleton 4' AND house_id = #{self.id}",
								:joins => :houses,
								:order => "last_name, first_name ASC")
	end
end
