# = DatabaseUpdate
#
# Author: Bradley J. Spaulding
#
# === Purpose
# DatabaseUpdate encapsulates a particular instance of a spreadsheet import,
# and contains all the logic for running that import on the database.
#
# Each time data is imported, a DatabaseUpdate is created, tracking:
# - the file location of the spreadsheet used
# - the date and time the update was run
# - the changes that were made, in the form designated below
# 
# === Storing Changes
# :changes is a Hash whose form depends on the update_type:
# 	Personnel Updates:
#     {:created => [id1, id2, id3, ...],
#      :updated => [[id4, attributeName, oldValue, newValue], ...]
#      :destroyed => ["PersonName1", "PersonName2", "PersonName3", ...]}
#		Certification Updates:
# 		{:course_title/certification_name => [ [person_id1, exp_date], ... ]
# Where each idN number is an id for a Person either created, updated or destroyed.
# serialize tells Rails to store changes as text, and convert it to a Hash upon retrieval
class DatabaseUpdate < ActiveRecord::Base
  serialize :changes, Hash
  
  # do not save a DatabaseUpdate without a spreadsheet_path, this is a required field
  validates_presence_of :spreadsheet_path
  
  # scope: most_recent, returns the most recent update
  named_scope :by_creation_desc, :order => "created_at DESC"
  
  # before the first save of each instance, do the data import
  before_create :import_data
  
  private
  
  # Opens the spreadsheet and run updates on the database, storing changes as above.
  # 
  # Throws CallLogExceptions::InvalidSpreadsheetError when appropriate.
  def import_data
    RAILS_DEFAULT_LOGGER.info "Inside import_data"
    # Open the spreadsheet
    workbook = Spreadsheet::ParseExcel.parse(spreadsheet_path)
    worksheet = workbook.worksheet(0)
    # Check the headers, run the import only if they're correct
    # store each hrid found in hrids, so that we can easily delete people later
    # also initialize changes to a containing the expected arrays
    if(valid_headers?(worksheet.row(0)))
      case self.update_type
      	when "Personnel"
      		RAILS_DEFAULT_LOGGER.info "Detected Personnel Import"
      		do_personnel_import(worksheet)	
      	when "Certifications"
      		RAILS_DEFAULT_LOGGER.info "Detected Certification Import"
      		do_certification_import(worksheet)
      	else
      		RAILS_DEFAULT_LOGGER.info "Update_Type not set!"
      		raise "update_type not set!"
      end
    else
      # raise an InvalidSpreadsheetError
      raise CallLogExceptions::InvalidSpreadsheetError
    end
  end
  
  # Header constants
  # Valid Personnel Spreadsheet Headers
  VALID_PERSONNEL_HEADERS = [	"PERSON_ID", "FIRST_NAME", "LAST_NAME", "PHONE_NUMBER", "MOBILE_TEL_NO",
                    					"EMAIL_ADDRESS", "GENDER", "ADDRESS1", "ADDRESS2", "CITY", "STATEPROV_NAME",
                    					"ZIP_POST_CODE", "EMPL_HIRE_DATE", "BU_CODE", "JOB_TITLE" ]
  # Valid Certification Spreadsheet Headers
  VALID_CERTIFICATION_HEADERS = [	"PERSON_ID", "FIRST_NAME", "LAST_NAME", "BU_CODE", "JOB_TITLE", "COURSE_TITLE", "RECERT_DUE_DATE" ]
  
  # Returns true if headers are valid, false if invalid
  #
  # Additionally, sets update_type to the observed spreadsheet type.
	#
  # Header_row is an array of the string headers
  def valid_headers?(header_row)
    # Check against Personnel Headers first.
    if valid_personnel_headers?(header_row)
    	self.update_type = "Personnel"
    	return true
    elsif valid_certification_headers?(header_row)
    	self.update_type = "Certifications"
    	return true
    end
    return false
  end
  
  # Returns true if header_row matches VALID_PERSONNEL_HEADERS, false otherwise.
  def valid_personnel_headers?(header_row)
  	return arrays_match header_row, VALID_PERSONNEL_HEADERS
  end
  
  # Returns true if header_row matches VALID_CERTIFICATION_HEADERS, false otherwise.
  def valid_certification_headers?(header_row)
  	return arrays_match header_row, VALID_CERTIFICATION_HEADERS
  end
  
  # Returns true if each element of a1 is the same as the first elements of a2
  def arrays_match(a1, a2)
  	a2.each_with_index do |a2_column, index|
  		clean_s = clean_str(a1[index].to_s)
  		if(clean_s != a2_column)
  			return false
  		end
  	end
  	return true
  end
  
  # Precondition: valid_headers? has been called.
  # 
  # Runs an import on the passed in worksheet as a certification import
  def do_certification_import(worksheet)
  	self.changes = {}
  	# Iterate each row in the spreadsheet
  	worksheet.each(1) do |row|
  		person = Person.find_by_hrid(clean_str(row[0].to_s).to_i)
  		unless person.nil? # ignore if no one exists
  			course_title = clean_str(row[5].to_s)
  			recert_due_date = row[6].date
  			cert = Certification.find_or_create_by_name(course_title)
  			pc = PersonsCertification.create!(
  							:expiration_date => recert_due_date,
  							:person => person,
  							:certification => cert)
  			pc.save!
  			
  			if self.changes[course_title.to_sym].nil?
  				self.changes[course_title.to_sym] = [person.id, recert_due_date.to_s]
  			else
  				self.changes[course_title.to_sym] << [person.id, recert_due_date.to_s]
  			end
  		end
  	end  	
  end
  
  # Precondition: valid_headers? has been called.
  # 
  # Runs an import on the passed in worksheet as a personnel import
  def do_personnel_import(worksheet)
  	self[:changes] = {:created => [], :updated => [], :destroyed => []}
  	hrids = []
  	# Iterate each row in the spreadsheet
    worksheet.each(1) do |row|
      # extract values appropriately
      attrs = {}
      attrs[:hrid] = clean_str(row[0].to_s).to_i
      attrs[:first_name] = clean_str(row[1].to_s)
      attrs[:last_name] = clean_str(row[2].to_s)
      attrs[:home_phone] = clean_str(row[3].to_s)
      attrs[:mobile_phone] = clean_str(row[4].to_s)
      attrs[:email_address] = clean_str(row[5].to_s)
      attrs[:gender] = (row[6].to_s == 'M') ? "male" : "female" # reformat for native convention
      attrs[:address_street] = [clean_str(row[7].to_s), clean_str(row[8].to_s)].join("\n") # concatenate address1 and address2
      attrs[:address_city] = clean_str(row[9].to_s)
      attrs[:address_state] = clean_str(row[10].to_s)
      attrs[:address_zip] = clean_str(row[11].to_s)
      attrs[:doh] = row[12].date
      pay_rate_split = row[13].to_s.split(".") # split the pay_rate instead of storing as a float
      attrs[:pay_rate_dollars] = pay_rate_split[0].to_i
      attrs[:pay_rate_cents] = pay_rate_split[1].to_i
      attrs[:bu_code] = row[14].to_s.to_i
      attrs[:position] = clean_str(row[15].to_s.titleize)
      
      # record hrid
      hrids << attrs[:hrid]
      
      # check to see if this is a new person, if so create it
      Rails.logger.info "Working on person with hrid = '#{attrs[:hrid]}'"
      person = Person.find_by_hrid(attrs[:hrid])
      if(person.nil?)
        # we have a new person, create this person
        person = Person.create!(attrs)
        # report the change to log and self.changes
        RAILS_DEFAULT_LOGGER.info "Created Person {:id => #{person.id}, :name => #{person.name}}"
        self[:changes][:created] << person.id
      else
        # this person exists, update each attribute as necessary and report changes
        person.attributes.each_pair do |attrName, attrValue|
          # ignore id, created_at and updated_at
          unless(attrName == "created_at" || attrName == "updated_at" || attrName == "id" || attrName == "password_salt" || attrName == "password_hash")
            if(attrs[attrName.to_sym] != attrValue)
              # this attribute needs to be updated, update it
              person.update_attribute(attrName, attrs[attrName.to_sym])
              # report the change to log and self.changes
              RAILS_DEFAULT_LOGGER.info "Updated Person {:id => #{person.id}, :name => #{person.name}, :#{attrName} => #{attrs[attrName.to_sym]}}"
              self[:changes][:updated] << [person.id, attrName, attrValue, attrs[attrName.to_sym]]
            end
          end
        end
      end
    end
    
    # delete everyone with an hrid not found in hrids, report the changes
    deletable_people = Person.find(:all, :conditions => "hrid != #{hrids.join(' AND hrid != ')}")
    deletable_people.each do |person|
      self[:changes][:destroyed] << person.name
      RAILS_DEFAULT_LOGGER.info "Deleted Person {:id => #{person.id}, :name => #{person.name}}"
      person.destroy
    end
  end
  
  # removes null characters from the input string
  def clean_str(s)
  	clean_s = ""
  	s.each_byte {|c| clean_s += "#{c.chr}" unless c == 0}
  	clean_s
  end
end