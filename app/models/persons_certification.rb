# = PersonsCertification
#
# === Purpose
# An association class, PersonsCertification exists to track the expiration date on one of a Person's Certifications.
#
# === Associations
# - belongs_to :person[link:Person.html]
# - belongs_to :certification[link:Certification.html]
#
class PersonsCertification < ActiveRecord::Base
  belongs_to :person
  belongs_to :certification
end