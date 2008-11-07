class Certification < ActiveRecord::Base
  has_many :persons_certifications
  has_many :people, :through => :persons_certifications
end