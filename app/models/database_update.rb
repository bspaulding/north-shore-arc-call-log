# DatabaseUpdate
# --------------------
# Each time data is imported, a DatabaseUpdate is created, tracking:
#     - the file location of the spreadsheet used
#     - the date and time the update was run
#     - the changes that were made, in the form designated below
class DatabaseUpdate < ActiveRecord::Base
  # changes is a Hash of the following form:
  #     {:created => [id1, id2, id3, ...],
  #      :updated => [[id4, attributeName, oldValue, newValue], ...]
  #      :destroyed => ["PersonName1", "PersonName2", "PersonName3", ...]}
  # where each idN number is an id for a Person either created, updated or destroyed.
  # serialize tells Rails to store changes as text, and convert it to a Hash upon retrieval
  serialize :changes, Hash
  
  # do not save a DatabaseUpdate without a spreadsheet_path, this is a required field
  validates_presence_of :spreadsheet_path
  
  # scope: most_recent, returns the most recent update
  named_scope :by_creation_desc, :order => "created_at DESC"
  
  # before the first save of each instance, do the data import
  before_create :import_data
  
  private
  
  # import_data
  # returns: void
  # purpose: open the spreadsheet and run updates on the database, storing changes as above
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
            unless(attrName == "created_at" || attrName == "updated_at" || attrName == "id")
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
    else
      # raise an InvalidSpreadsheetError
      raise CallLogExceptions::InvalidSpreadsheetError
    end
  end
  
  VALID_HEADERS = ["PERSON_ID", "FIRST_NAME", "LAST_NAME", "PHONE_NUMBER", "MOBILE_TEL_NO",
                    "EMAIL_ADDRESS", "GENDER", "ADDRESS1", "ADDRESS2", "CITY", "STATEPROV_NAME",
                    "ZIP_POST_CODE", "EMPL_HIRE_DATE", "SAL_BASE_HRLY", "BU_CODE"]
  
  # valid_headers
  # params: 
  #     - header_row: an array of the string headers
  # returns: true if headers are valid, false if invalid
  def valid_headers?(header_row)
    RAILS_DEFAULT_LOGGER.info "Inside valid_headers?"
    # Each of the cells are compared individually, 
    # because the header_row may contain empty cells at the end
    VALID_HEADERS.each_with_index do |valid_header, index|
      if(header_row[index].to_s != valid_header)
        RAILS_DEFAULT_LOGGER.info "returning false, '#{header_row[index]}' != '#{valid_header}'"
        return false
      end
    end
    RAILS_DEFAULT_LOGGER.info "returning true"
    return true
  end
end
