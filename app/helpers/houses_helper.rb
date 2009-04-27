# Helper methods available to templates under HousesController
module HousesHelper
	# Returns a formatted house address block for a particular house.
	def house_address(house)
		address_str = ""
		(house.address_street == House::DEFAULT_ADDRESS_STREET) ? nil : address_str += "#{house.address_street}<br/>"
		(house.address_city == House::DEFAULT_ADDRESS_CITY) ? nil : address_str += "#{house.address_city}, "
		(house.address_state == House::DEFAULT_ADDRESS_STATE) ? nil : address_str += "#{house.address_state} "
		(house.address_zip == House::DEFAULT_ADDRESS_ZIP) ? nil : address_str += "#{house.address_zip}"
		address_str
	end
	
	# Returns a formatted phone number block for a particular house.
	def house_phones(house)
		phones = []
		phones << house.phone_1 unless house.phone_1.blank? || house.phone_1 == House::DEFAULT_PHONE_1
		phones << house.phone_1 unless house.phone_2.blank? || house.phone_2 == House::DEFAULT_PHONE_2
		phones << house.fax unless house.fax.blank? || house.fax == House::DEFAULT_FAX
		phones.join(' // ')
	end
end
