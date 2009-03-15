class Person < ActiveRecord::Base
  has_many :persons_certifications
  has_many :certifications, :through => :persons_certifications
  
  has_and_belongs_to_many :houses
  
  named_scope :with_hrid, lambda { |hrid| { :conditions => { :hrid => hrid } } }
  named_scope :from_bu, lambda { |bu_code| { :conditions => {:bu_code => bu_code } } }
#  named_scope :with_certifications, lambda { |certifications| {
#      
#  } }
# TODO: Handle with_certifications named_scope, should take an array of certifications a candidate must have
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def name=(new_name)
  	# new_name is split by the space
  	names = new_name.strip.split(' ')
  	self.first_name = names[0]
  	self.last_name = names[1]
  	self.save!
  end
end
