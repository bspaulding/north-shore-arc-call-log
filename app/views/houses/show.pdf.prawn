def print_table(pdf, collection, collection_name, headings = ["Name", "Position", "Trainings", "Phone Number(s)"])
	if collection.empty?
		pdf.text	"No #{collection_name} are assigned to this house profile.",
							:style => :italic,
							:size => 10
	else
		pdf.table collection.map { |hd| 
			[	
				hd.name.to_s, 
				hd.position.to_s, 
				hd.certifications.collect { |cert| cert.name	}.join('\n'),
				"Home: #{(hd.home_phone.blank?) ? 'None' : hd.home_phone}\nMobile: #{(hd.mobile_phone.blank?) ? 'None' : hd.mobile_phone}"
			]
		},	:border_style => :grid,
				:row_colors => ["FFFFFF", "DDDDDD"],
				:headers => headings,
				:header_color => "999999",
				:align => { 0 => :left, 1 => :left, 2 => :left, 3 => :left },
				:widths => { 0 => 120, 1 => 120, 2 => 200, 3 => 100 }	
	end
end

pdf.font "Times-Roman"

logo = "#{RAILS_ROOT}/public/images/nsarc_logo.jpg"
pdf.image logo, :scale => 0.5, :position => :center, :vposition => :top

pdf.text @house.name, :style => :bold, :size => 18

pdf.move_down(10)

pdf.text "Directors", :style => :bold, :size => 12
directors = @house.house_directors + @house.asst_div_directors + @house.clinical_managers + @house.asst_house_managers
print_table pdf, directors, "Directors"

pdf.move_down(10)

pdf.text "House Managers", :style => :bold, :size => 12
print_table pdf, @house.house_managers, "House Managers"

pdf.move_down(10)

pdf.text "Overnight Managers", :style => :bold, :size => 12
print_table pdf, @house.awake_overnights, "Overnight Managers"

pdf.move_down(10)

pdf.text "Relief Staff", :style => :bold, :size => 12
relief_staff = @house.relief_staff
if relief_staff.empty?
	pdf.text	"No Relief Staff are assigned to this house profile.", 
						:style => :italic
else
	print_table pdf, relief_staff
end

pdf.move_down(10)

pdf.text "Overtime Staff", :style => :bold, :size => 12
print_table pdf, @house.overtime_staff, "Overtime Staff"