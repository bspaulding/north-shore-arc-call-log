# = Individual
#
# === Purpose
# Encapsulates an Individual on a House profile.
#
# === Associations
# - has_and_belongs_to_many :houses[link:House.html]
class Individual < ActiveRecord::Base
	# Constants
	DEFAULT_GUARDIAN_NAME = "Add Guardian Name"
	DEFAULT_GUARDIAN_PHONE_HOME = "Add Phone Number"
	DEFAULT_GUARDIAN_PHONE_WORK = "Add Phone Number"
	DEFAULT_GUARDIAN_PHONE_MOBILE = "Add Phone Number"
	DEFAULT_PCP = "Add PCP"
	DEFAULT_PCP_PHONE = "Add Phone Number"
	DEFAULT_DAY_PROGRAM = "Add Day Program"
	DEFAULT_DAY_PROGRAM_PHONE = "Add Phone Number"
 	DEFAULT_TRANSPORTATION = "Add Transportation"
 	DEFAULT_TRANSPORTATION_PHONE = "Add Phone Number"
	
	# Associations
	has_and_belongs_to_many :houses
	
	# Before creation, set default values
	before_create :set_defaults
	
	# Called before first instance save, sets the default values if fields are blank
	def set_defaults
		self.guardian_name = DEFAULT_GUARDIAN_NAME if guardian_name.blank?
		self.guardian_phone_home = DEFAULT_GUARDIAN_PHONE_HOME,
		self.guardian_phone_work = DEFAULT_GUARDIAN_PHONE_WORK,
		self.guardian_phone_mobile = DEFAULT_GUARDIAN_PHONE_MOBILE,
		self.pcp = DEFAULT_PCP,
		self.pcp_phone_number = DEFAULT_PCP_PHONE,
		self.day_program = DEFAULT_DAY_PROGRAM,
		self.day_program_phone = DEFAULT_DAY_PROGRAM_PHONE,
		self.transportation = DEFAULT_TRANSPORTATION,
		self.transportation_phone = DEFAULT_TRANSPORTATION_PHONE
	end
end