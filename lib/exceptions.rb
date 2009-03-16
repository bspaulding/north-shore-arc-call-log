# Module CallLogExceptions 
# defines application specific errors, which extend from the appropriate ruby base class.
# Author: Bradley J. Spaulding
module CallLogExceptions
  # InvalidSpreadsheet
  # Raised when a spreadsheet is detected to be invalid.
  class InvalidSpreadsheetError < StandardError; end
  class InvalidUser < StandardError; end
end