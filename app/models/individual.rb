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
end
