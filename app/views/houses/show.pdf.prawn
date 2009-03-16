pdf.font "Times-Roman"

logo = "#{RAILS_ROOT}/public/images/nsarc_logo.jpg"
pdf.image logo, :scale => 0.5, :position => :center, :vposition => :top

pdf.text @house.name, :style => :bold, :size => 18

pdf.text "Directors", :style => :bold, :size => 12
hds = @house.house_directors.collect { |hd| 
				[	hd.name.to_s, 
					hd.position.to_s, 
					hd.certifications.collect { |cert| cert.name	}.join('\n'),
					"Home: #{(hd.home_phone.nil?) ? 'None' : hd.home_phone}\nMobile: #{(hd.mobile_phone.nil?) ? 'None' : hd.mobile_phone}"]
			}

pdf.table hds

pdf.text "House Managers", :style => :bold, :size => 12

pdf.text "Overnight Managers", :style => :bold, :size => 12

pdf.text "Relief Staff", :style => :bold, :size => 12

pdf.text "Overtime Staff", :style => :bold, :size => 12