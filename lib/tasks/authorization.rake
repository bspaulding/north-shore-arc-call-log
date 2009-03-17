task :set_default_authorizations => :environment do
	Role.destroy_all
	Right.destroy_all
	
	# DirectCareProvider
	dcp = Role.create!(:name => "DirectCareProvider")
	profiles = Right.create!(:name => "User Profiles", :controller => "people", :action => "show")
	dcp.rights << profiles
	
	# Supervisor
	s = Role.create!(:name => "Supervisor")
	super_home = Right.create!(	:name => "Supervisor Controller (all)",
															:controller => "supervisor")
	s.rights << super_home
	houses_all = Right.create!(	:name => "Houses (all)",
															:controller => "houses")
	s.rights << houses_all
	adv_searches_all = Right.create!(	:name => "AdvancedSearches (all)",
															:controller => "advanced_searches")
	s.rights << adv_searches_all
	dbups_show = Right.create!(	:name => "DatabaseUpdates (show)",
															:controller => "database_updates",
															:action => "show")
	s.rights << dbups_show
	people_all = Right.create!(	:name => "People (all)",
															:controller => "people")
	s.rights << people_all
	
	# Administrator
	admin = Role.create!(	:name => "Administrator")
	all_access = Right.create!(	:name => "All Access")
	admin.rights << all_access
	
	# Give Everyone at least the DirectCareProvider role
	Person.all.each do |person|
		unless person.roles.member?(dcp)
			person.roles << dcp
		end
	end
end