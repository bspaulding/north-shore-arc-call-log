# = AdvancedSearch
#
# === Purpose
# Encapsulates a People search query in order to provide 
# flexibility, repeatablity, and editability to each query.
#
# === Associations
# - has_and_belongs_to_many :certifications[link:Certification.html]
#
# === Usage
# Create an instance of AdvancedSearch, populated with the desired query structure.
# The entry point for performing searches is the public method people.
# 	search = AdvancedSearch.create(:last_name => "Keel")
# 	results = search.people
# 	# => [<Person>, <Person>, ...] (where last_name is like '%Keel%')
#
# === Implementation
# The conditions for each query are formed by the method conditions, which 
# collects and merges all the results of any methods named '*_conditions'.
#
# In this way, new conditions can be dynamically added by creating an additional method.
#
# For example, if we now wanted to search on job_title, field we've added to Person and AdvancedSearch,
# we would add the following method:
# 	def job_title_conditions
# 	  ["people.job_title LIKE ?", "%#{job_title}%"] unless job_title.blank?
# 	end
#
class AdvancedSearch < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :certifications
  
  # This is the entry point for searches to be performed. 
  # Returns: An array of Person objects as the results of this query.
  def people
    # Cache the results in memory
    @people ||= find_people
  end
  
  private 
  
  # Worker method for people. Calls conditions to form an array of all query conditions.
  def find_people
  	Person.find(:all, :conditions => conditions, :order => "last_name, first_name ASC")
  end
 
	# Generates a SQL clause to find all people with first_names like this instance's first_name
  def first_name_conditions
    ["people.first_name LIKE ?", "%#{first_name}%"] unless first_name.blank?
  end

	# Generates a SQL clause to find all people with last_names like this instance's last_name
  def last_name_conditions
    ["people.last_name LIKE ?", "%#{last_name}%"] unless last_name.blank?
  end

	# Generates a SQL clause to find all people with nicknames like this instance's nickname
  def nickname_conditions
    ["people.nickname LIKE ?", "%#{nickname}%"] unless nickname.blank?
  end

	# Generates a SQL clause to find all people with email_addresses like this instance's email
  def email_conditions
    ["people.email_address LIKE ?", "%#{email}%"] unless email.blank?
  end

	# Generates a SQL clause to find all people whose gender is the same as this instance's gender
  def gender_conditions
    ["gender = ?", gender] unless gender.blank?
  end

	# Generates a SQL clause to find all people with home_phones like this instance's home_phone
  def home_phone_conditions
    ["people.home_phone LIKE ?", "%#{home_phone}%"] unless home_phone.blank?
  end

	# Generates a SQL clause to find all people with mobile_phones like this instance's mobile_phone
  def mobile_phone_conditions
    ["people.mobile_phone LIKE ?", "%#{mobile_phone}%"] unless mobile_phone.blank?
  end

	# Generates a SQL clause to find all people with address_streets like this instance's address_street
  def address_street_conditions
    ["people.address_street LIKE ?", "%#{address_street}%"] unless address_street.blank?
  end
	
	# Generates a SQL clause to find all people with address_cities like this instance's address_city
  def address_city_conditions
    ["people.address_city LIKE ?", "%#{address_city}%"] unless address_city.blank?
  end

	# Generates a SQL clause to find all people with address_states like this instance's address_state
  def address_state_conditions
    ["people.address_state LIKE ?", "%#{address_state}%"] unless address_state.blank?
  end

	# Generates a SQL clause to find all people with address_zips like this instance's address_zip
  def address_zip_conditions
    ["people.address_zip LIKE ?", "%#{address_zip}%"] unless address_zip.blank?
  end

	# Generates a SQL clause to find all people with doh (date of hire) before this instance's hired_before
  def hired_before_conditions
    ["people.doh >= ?", hired_before] unless hired_before.blank?
  end
	
	# Generates a SQL clause to find all people with doh (date of hire) after this instance's hired_after
  def hired_after_conditions
    ["people.doh <= ?", hired_after] unless hired_after.blank?
  end

	# Generates a SQL clause to find people who have at least all
	# the certifications associated with this instance of AdvancedSearch.
	def certifications_conditions
		unless certifications.empty?
			selects = []
			certifications.each do |cert|
				selects.push "select person_id from persons_certifications where certification_id = #{cert.id}"
			end
			["id IN (#{selects.join(' INTERSECT ')})"]
		end
	end

  # Returns an array of all the SQL conditional clauses
  # for this query. 
  # collects results of all methods named '*_conditions' within this class.
  # The last three conditions_* methods are helpers.
  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

	# Helper to conditions
  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  # Helper to conditions
  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

	# Helper to conditions
  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
end
