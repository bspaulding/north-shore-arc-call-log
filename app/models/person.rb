class Person < ActiveRecord::Base
  has_many :persons_certifications
  has_many :certifications, :through => :persons_certifications
  
  def name
    "#{first_name} #{last_name}"
  end
end
