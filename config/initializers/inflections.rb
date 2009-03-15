# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format 
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

ActiveSupport::Inflector.inflections do |inflect|
	#inflect.human 'address_street', "Street address"
	#inflect.human 'address_city', "City"
	#inflect.human 'address_state', "State"
	#inflect.human 'address_zip', "Zip Code"
	
	inflect.human "address_street", "Address (Street)"
	inflect.human "address_city", "Address (City)"
	inflect.human "address_state", "Address (State)"
	inflect.human "address_zip", "Address (Zip Code)"
end