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
# :changes is a Hash of the following form:
#     {:created => [id1, id2, id3, ...],
#      :updated => [[id4, attributeName, oldValue, newValue], ...]
#      :destroyed => ["PersonName1", "PersonName2", "PersonName3", ...]}
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
    self[:changes] = {:created => [], :updated => [], :destroyed => []}
    hrids = []
    if(valid_headers?(worksheet.row(0)))
      case self.update_type
      	when "Personnel"
      		do_personnel_import(worksheet)	
      	when "Certifications"
      		do_certification_import(worksheet)
      	else
      		raise "update_type not set!"
      end
      
      # delete everyone with an hrid not found in hrids, report the changes
      deletable_people = Person.find(:all, :conditions => "hrid != #{hrids.join(' AND hrid != ')}")
      deletable_people.each do |person|
        self[:changes][:destroyed] << person.name
        RAILS_DEFAULT_LOGGER.info "Deleted Person {:id => #{person.id}, :name => #{person.name}}"
        person.destroy
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
    if valid_personel_headers?(header_row)
    	self.update_type = "Personnel"
    	return true
    elsif valid_certification_headers?(header_row)
    	self.update_type = "Certifications"
    	return true
    else
    	return false
    end
  end
  
  # Returns true if header_row matches VALID_PERSONNEL_HEADERS, false otherwise.
  def valid_personnel_headers?(header_row)
	  # Each of the cells are compared individually, 
    # because the header_row may contain empty cells at the end
  	VALID_PERSONNEL_HEADERS.each_with_index do |valid_header, index|
      if(header_row[index].to_s != valid_header)
        return false
      end
    end
    return true
  end
  
  # Returns true if header_row matches VALID_CERTIFICATION_HEADERS, false otherwise.
  def valid_certification_headers?(header_row)
	  # Each of the cells are compared individually, 
    # because the header_row may contain empty cells at the end
  	VALID_CERTIFICATION_HEADERS.each_with_index do |valid_header, index|
      if(header_row[index].to_s != valid_header)
        return false
      end
    end
    return true
  end
  
  # Precondition: valid_headers? has been called.
  # 
  # Runs an import on the passed in worksheet as a certification import
  def do_certification_import(worksheet)
  	# Iterate each row in the spreadsheet
  	worksheet.each(1) do |row|
  		# STUB
  	end  	
  end
  
  # Precondition: valid_headers? has been called.
  # 
  # Runs an import on the passed in worksheet as a personnel import
  def do_personnel_import(worksheet)
  	# Iterate each row in the spreadsheet
    worksheet.each(1) do |row|
      # extract values appropriately
      attrs = {}
      attrs[:hrid] = row[0].to_i
      attrs[:first_name] = row[1].to_s
      attrs[:last_name] = row[2].to_s
      attrs[:home_phone] = row[3].to_s
      attrs[:mobile_phone] = row[4].to_s
      attrs[:email_address] = row[5].to_s
      attrs[:gender] = (row[6].to_s == 'M') ? "male" : "female" # reformat for native convention
      attrs[:address_street] = [row[7].to_s, row[8].to_s].join("\n") # concatenate address1 and address2
      attrs[:address_city] = row[9].to_s
      attrs[:address_state] = row[10].to_s
      attrs[:address_zip] = row[11].to_s
      attrs[:doh] = row[12].date
      pay_rate_split = row[13].to_s.split(".") # split the pay_rate instead of storing as a float
      attrs[:pay_rate_dollars] = pay_rate_split[0].to_i
      attrs[:pay_rate_cents] = pay_rate_split[1].to_i
      attrs[:bu_code] = row[14].to_s.to_i
      attrs[:position] = row[15].to_s.titleize
      
      # record hrid
      hrids << attrs[:hrid]
      
      # check to see if this is a new person, if so create it
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
  end
end