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
	
	# Associations:
	has_and_belongs_to_many :people, :order => "last_name,first_name ASC"
	has_and_belongs_to_many :individuals
	
	# Categorized People Accessors
	#	positions = [	"House Director", "Asst. Div. Director", "Clinical Manager", "Asst. House Director",
	#								"House Manager", "Awake Overnight", "Relief", "Heritage Specialty", "Middleton 4"]
	def house_directors
		Person.find(:all, 
								:conditions => "people.position = 'House Director' AND house_id = #{self.id}", 
								:joins => :houses, 
								:order => "last_name, first_name ASC")
	end
	
	def asst_div_directors
		Person.find(:all, 
								:conditions => "people.position = 'Asst. Div. Director' AND house_id = #{self.id}", 
								:joins => :houses, 
								:order => "last_name, first_name ASC")
	end
	
	def clinical_managers
		Person.find(:all, 
								:conditions => "people.position = 'Clinical Manager' AND house_id = #{self.id}", 
								:joins => :houses, 
								:order => "last_name, first_name ASC")
	end
	
	def asst_house_managers
		Person.find(:all, 
								:conditions => "people.position = 'Asst. House Director' AND house_id = #{self.id}", 
								:joins => :houses, 
								:order => "last_name, first_name ASC")
	end
	
	def house_managers
		Person.find(:all, 
								:conditions => "people.position = 'House Manager' AND house_id = #{self.id}", 
								:joins => :houses, 
								:order => "last_name, first_name ASC")
	end
	
	def awake_overnights
		Person.find(:all,
								:conditions => "people.position = 'Awake Overnight' AND house_id = #{self.id}", 
								:joins => :houses, 
								:order => "last_name, first_name ASC")
	end
	
	def relief_staff
		Person.find(:all,
								:conditions => "people.position = 'Relief' AND house_id = #{self.id}",
								:joins => :houses,
								:order => "last_name, first_name ASC")
	end
	
	def overtime_staff
		Person.find(:all, 
								:conditions => "people.position = 'Heritage Specialty' AND house_id = #{self.id} OR people.position = 'Middleton 4' AND house_id = #{self.id}",
								:joins => :houses,
								:order => "last_name, first_name ASC")
	end
end
