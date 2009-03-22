# Helper methods available to templates under HousesController
module HousesHelper
	# Returns a formatted house address block for a particular house.
	def house_address(house)
		unless	house.address_street == House::DEFAULT_ADDRESS_STREET ||
						house.address_city == House::DEFAULT_ADDRESS_CITY ||
						house.address_state == House::DEFAULT_ADDRESS_STATE ||
						house.address_zip == House::DEFAULT_ADDRESS_ZIP
			"#{house.address_street}<br/>#{house.address_city}, #{house.address_state} #{house.address_zip}"
		end
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
