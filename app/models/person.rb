class Person < ActiveRecord::Base
  has_many :persons_certifications
  has_many :certifications, :through => :persons_certifications
  
  named_scope :with_hrid, lambda { |hrid| { :conditions => { :hrid => hrid } } }
  named_scope :from_bu, lambda { |bu_code| { :conditions => {:bu_code => bu_code } } }
#  named_scope :with_certifications, lambda { |certifications| {
#      
#  } }
# TODO: Handle with_certifications named_scope, should take an array of certifications a candidate must have
  
  def name
    "#{first_name} #{last_name}"
  end
end
