class SupervisorController < ApplicationController
  def index
  end
  
  def upload_spreadsheet
    # Create the spreadsheet file in /tmp and write the file's contents to it
    filename = "#{DateTime.now.strftime("%Y%m%d%H%M%S")}_sheet.xls"
    data = params[:file].read
    spreadsheet_file = File.new("#{RAILS_ROOT}/tmp/#{filename}", 'w+')
    spreadsheet_file.write(data)
    spreadsheet_file.close
    
    RAILS_DEFAULT_LOGGER.info("\n Spreadsheet File Path: #{spreadsheet_file.path} \n")
    
    @dbup = DatabaseUpdate.create(:spreadsheet_path => spreadsheet_file.path)
  end
end