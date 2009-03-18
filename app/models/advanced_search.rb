# Class: AdvancedSearch
# => Purpose: Encapsulate a complicated people search query
#             in order to more efficiently handle searching.
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
  
  # Initiates the find, conditions calls the conditions method
  def find_people
  	Person.find(:all, :conditions => conditions, :order => "last_name, first_name ASC")
  end
  
  # Note: All methods suffixed with '_conditions' return 
  #       conditional clauses for a particular attribute.
  def first_name_conditions
    ["people.first_name LIKE ?", "%#{first_name}%"] unless first_name.blank?
  end

  def last_name_conditions
    ["people.last_name LIKE ?", "%#{last_name}%"] unless last_name.blank?
  end

  def nickname_conditions
    ["people.nickname LIKE ?", "%#{nickname}%"] unless nickname.blank?
  end

  def email_conditions
    ["people.email_address LIKE ?", "%#{email}%"] unless email.blank?
  end

  def gender_conditions
    ["gender = ?", gender] unless gender.blank?
  end

  def home_phone_conditions
    ["people.home_phone LIKE ?", "%#{home_phone}%"] unless home_phone.blank?
  end

  def mobile_phone_conditions
    ["people.mobile_phone LIKE ?", "%#{mobile_phone}%"] unless mobile_phone.blank?
  end

  def address_street_conditions
    ["people.address_street LIKE ?", "%#{address_street}%"] unless address_street.blank?
  end

  def address_city_conditions
    ["people.address_city LIKE ?", "%#{address_city}%"] unless address_city.blank?
  end

  def address_state_conditions
    ["people.address_state LIKE ?", "%#{address_state}%"] unless address_state.blank?
  end

  def address_zip_conditions
    ["people.address_zip LIKE ?", "%#{address_zip}%"] unless address_zip.blank?
  end

  def hired_before_conditions
    ["people.doh >= ?", hired_before] unless hired_before.blank?
  end

  def hired_after_conditions
    ["people.doh <= ?", hired_after] unless hired_after.blank?
  end

	def certifications_conditions
		unless certifications.empty?
			selects = []
			certifications.each do |cert|
				selects.push "select person_id from persons_certifications where certification_id = #{cert.id}"
			end
			["id IN (#{selects.join(' INTERSECT ')})"]
		end
	end

  # Conditions: returns an array of all the SQL conditional clauses
  #             for this query. The last three conditions_* methods are helpers.
  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
end
