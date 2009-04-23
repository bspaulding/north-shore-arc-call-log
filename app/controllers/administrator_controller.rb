class AdministratorController < ApplicationController
	before_filter :authenticate, :authorize
	
	def index
		@admins, @supervisors, @direct_care_providers = get_admins_supers_and_dcps
	end
	
	def remove_admin
		admin_role = Role.find(:first, :conditions => {:name => "Administrator"})
		admins = admin_role.people
		
		if admins.size == 1
			flash[:error] = "Cannot Delete the Last Administrator."
			redirect_to :action => 'index'
		else
			person = Person.find(params[:person_id])
			person.roles.delete(admin_role)
			
			@admins, @supervisors, @direct_care_providers = get_admins_supers_and_dcps
			
			render :update do |page|
				page.replace_html 'administrators', :partial => 'administrators', :object => @admins
				page.replace_html 'supervisors', :partial => 'supervisors', :object => @supervisors
				page.visual_effect :highlight, 'administrators'
			end
		end
	end
	
	def remove_supervisor
		supervisor_role = Role.find(:first, :conditions => {:name => "Supervisor"})
		supervisors = supervisor_role.people
		
		if supervisors.size == 1
			flash[:error] = "Cannot Delete the Last Supervisor."
			redirect_to :action => 'index'
		else
			person = Person.find(params[:person_id])
			person.roles.delete(supervisor_role)
			
			@admins, @supervisors, @direct_care_providers = get_admins_supers_and_dcps
			
			render :update do |page|
				page.replace_html 'supervisors', :partial => 'supervisors', :object => @supervisors
				page.visual_effect :highlight, 'supervisors'
			end
		end
	end
	
	def make_administrator
		person = Person.find(params[:id])
		Role.all.each do |role|
			if !person.roles.member?(role)
				person.roles << role
			end
		end
		person.save!
		
		@admins, @supervisors, @direct_care_providers = get_admins_supers_and_dcps
		
		render :update do |page|
			page.replace_html 'manage_roles', 
												:partial => 'manage_roles',
												:locals => {
													:admins => @admins, 
													:supers => @supervisors, 
													:dcps => @direct_care_providers
												}
			page.visual_effect :highlight, 'administrators'
		end
	end
	
	def make_supervisor
		person = Person.find(params[:id])
		admin_role = Role.find(:first, :conditions => {:name => "Administrator"})
		supervisor_role = Role.find(:first, :conditions => {:name => "Supervisor"})
		direct_care_role = Role.find(:first, :conditions => {:name => "DirectCareProvider"})
		
		if person.admin? && admin_role.people.size == 1
			# person cannot be the last admin
			Rails.logger.info "Cannot Delete the last admin."
			flash[:error] = "Cannot Delete the Last Administrator."
			redirect_to :action => 'index'
		else
			person.roles.delete_all
			person.roles << direct_care_role
			person.roles << supervisor_role
			person.save!
		
			@admins, @supervisors, @direct_care_providers = get_admins_supers_and_dcps
			
			render :update do |page|
				page.replace_html 'manage_roles', 
													:partial => 'manage_roles',
													:locals => {
														:admins => @admins, 
														:supers => @supervisors, 
														:dcps => @direct_care_providers
													}
				page.visual_effect :highlight, 'supervisors'
			end
		end
	end
	
	def make_direct_care
		person = Person.find(params[:id])
		admin_role = Role.find(:first, :conditions => {:name => "Administrator"})
		supervisor_role = Role.find(:first, :conditions => {:name => "Supervisor"})
		direct_care_role = Role.find(:first, :conditions => {:name => "DirectCareProvider"})
		
		if person.admin? && admin_role.people.size == 1
			# person cannot be the last admin
			flash[:error] = "Cannot Delete the Last Administrator."
			redirect_to :action => 'index'
		else
			person.roles.delete_all
			person.roles << direct_care_role
			person.save!
		
			@admins, @supervisors, @direct_care_providers = get_admins_supers_and_dcps
			
			render :update do |page|
				page.replace_html 'manage_roles', 
													:partial => 'manage_roles',
													:locals => {
														:admins => @admins, 
														:supers => @supervisors, 
														:dcps => @direct_care_providers
													}
				page.visual_effect :highlight, 'direct_care_providers'
			end
		end
	end
	
	["administrator", "supervisor", "direct_care"].each do |role|
		define_method("update_manage_#{role}_buttons") do 
			render :update do |page|
				page.replace_html	"manage_#{role}_buttons", 
													:partial => "manage_#{role}_buttons", 
													:object => Person.find(params["#{role}_id"])
			end
		end
	end
		
	private 
	
	def get_admins_supers_and_dcps
		admins = Role.find(:first, :conditions => {:name => "Administrator"}).people
		supervisors = Role.find(:first, :conditions => {:name => "Supervisor"}).people - admins
		direct_care_providers = Role.find(:first, :conditions => {:name => "DirectCareProvider"}).people - admins - supervisors
		return admins, supervisors, direct_care_providers
	end
end
