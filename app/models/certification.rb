class Certification < ActiveRecord::Base
	# Associations
  has_many :persons_certifications
  has_many :people, :through => :persons_certifications
  has_and_belongs_to_many :advanced_searches
end