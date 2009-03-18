module HousesHelper
	def house_address(house)
		unless	house.address_street == House::DEFAULT_ADDRESS_STREET ||
						house.address_city == House::DEFAULT_ADDRESS_CITY ||
						house.address_state == House::DEFAULT_ADDRESS_STATE ||
						house.address_zip == House::DEFAULT_ADDRESS_ZIP
			"#{house.address_street}<br/>#{house.address_city}, #{house.address_state} #{house.address_zip}"
		end
	end
	
	def house_phones(house)
		"#{house.phone_1 unless	house.phone_1 == House::DEFAULT_PHONE_1} #{house.phone_2 unless house.phone_2 == House::DEFAULT_PHONE_2} #{house.fax unless house.fax == House::DEFAULT_FAX}"
	end
end
