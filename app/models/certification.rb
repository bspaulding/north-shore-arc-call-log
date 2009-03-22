# = Certification
#
# === Purpose
# Encapsulates a Certification.
#
# === Associations
# - has_many :persons_certifications[link:PersonsCertifications.html]
# - has_many :people[link:Person.html], :through => :persons_certifications[link:PersonsCertifications.html]
# - has_and_belongs_to_many :advanced_searches[link:AdvancedSearch.html]
class Certification < ActiveRecord::Base
	# Associations
  has_many :persons_certifications
  has_many :people, :through => :persons_certifications
  has_and_belongs_to_many :advanced_searches
end