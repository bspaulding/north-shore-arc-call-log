# Helper methods available to templates under HousesController
module HousesHelper
	# Returns a formatted house address block for a particular house.
	def house_address(house)
		address_str = ""
		(house.address_street == House::DEFAULT_ADDRESS_STREET) ? address_str += "#{house.address_street}<br/>" : nil
		(house.address_city == House::DEFAULT_ADDRESS_CITY) ? address_str += "#{house.address_city}, " : nil
		(house.address_state == House::DEFAULT_ADDRESS_STATE) ? address_str += "#{house.address_state} " : nil
		(house.address_zip == House::DEFAULT_ADDRESS_ZIP) ? address_str += "#{house.address_zip}" : nil
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
