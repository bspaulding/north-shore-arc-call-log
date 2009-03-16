task :fix_phones => :environment do 
	Person.all.each do |person|
		person.home_phone = person.home_phone.gsub(/[^0-9]/, '') unless person.home_phone.nil?
		person.mobile_phone = person.mobile_phone.gsub(/[^0-9]/, '') unless person.mobile_phone.nil?
		person.save!
	end
end