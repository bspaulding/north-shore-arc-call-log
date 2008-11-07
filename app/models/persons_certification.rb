class PersonsCertification < ActiveRecord::Base
  belongs_to :person
  belongs_to :certification
end