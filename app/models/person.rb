# = Person
#
# === Purpose
# Encapsulates a Person.
#
# === Associations
# - has_many :persons_certifications[link:PersonsCertification.html]
# - has_many :certifications[link:Certification.html], :through => :persons_certifications[link:PersonsCertification.html]
# - has_and_belongs_to_many :houses[link:House.html]
# - has_and_belongs_to_many :roles[link:Role.html]
#
require 'digest/sha2'
class Person < ActiveRecord::Base
  # Associations
  has_many :persons_certifications
  has_many :certifications, :through => :persons_certifications
  has_and_belongs_to_many :houses
  has_and_belongs_to_many :roles
  
  file_column :image
  
  # Scopes
  named_scope :with_hrid, lambda { |hrid| { :conditions => { :hrid => hrid } } }
  named_scope :from_bu, lambda { |bu_code| { :conditions => {:bu_code => bu_code } } }

	# Validations
	validates_uniqueness_of :email_address, :allow_nil => true, :allow_blank => true

	# Authenticate an email/pass Combination. Returns true if combination is valid.
	def self.authenticate(email_address, password)
		person = Person.find(:first, :conditions => {:email_address => email_address})
		if person.blank? || password.blank? || person.password_salt.blank? || Digest::SHA256.hexdigest(password + person.password_salt) != person.password_hash
			raise CallLogExceptions::InvalidUser
		end
		person
	end
	
	# Sets the user's password.
	def password=(new_password)
		salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
		self.password_salt, self.password_hash = salt, Digest::SHA256.hexdigest(new_password + salt)
	end
	
  # Virtual Getter for 'name'
  def name
    "#{first_name} #{last_name}"
  end
  
  # Virtual Setter for 'name' (first_name, last_name)
  def name=(new_name)
  	# new_name is split by the space
  	names = new_name.strip.split(' ')
  	self.first_name = names[0]
  	self.last_name = names[1]
  	self.save!
  end
  
  # Returns true is this user is an administrator
  def admin?
  	roles.member?(Role.find(:first, :conditions => {:name => "Administrator"}))
  end
end
