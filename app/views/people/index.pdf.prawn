people_cells = @people.collect do |person|
	[	(person.first_name.nil?) ? "" : person.first_name,
		(person.last_name.nil?) ? "" : person.last_name,
		(person.gender == "male") ? "M" : "F",
		(person.email_address.nil?) ? "" : person.email_address,
		(person.home_phone.nil?) ? "" : person.home_phone,
		(person.mobile_phone.nil?) ? "" : person.mobile_phone,
		(person.address.nil?) ? "" : person.address,
		person.persons_certifications.collect {|pc|
			exp_date = (pc.expiration_date.nil?) ? "" : pc.expiration_date.strftime("%B %d, %Y")
			"#{pc.certification.name} - #{exp_date}"
		}.join("\n")
	]
end

pdf.table people_cells,
					:font_size => 8,
					:horizontal_padding => 5,
					:vertical_padding => 5,
					:border_width => 1,
					:position => :center,
					:headers => ["First", "Last", "", "Email", "Home Phone", "Mobile Phone", "Address", "Certifications"],
					:align => :left,
					:border_style => :grid,
					:header_color => "CCCCCC",
					:row_colors => ["FFFFFF", "EEEEEE"]