# Controller: DatabaseUpdatesController
# Author: Bradley J. Spaulding
# Purpose: Handles all requests for the DatabaseUpdate resource, all routes under /database_updates
class DatabaseUpdatesController < ApplicationController
  # Route: /database_updates (GET)
  # Purpose: renders a list of all database updates, newest first
  def index
    @updates = DatabaseUpdate.all(:order => "created_at DESC")
  end

  # Route: /database_updates/:id (GET)
  # Purpose: renders detailed information for the DatabaseUpdate with id = :id
  def show
    begin
      @update = DatabaseUpdate.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      #flash[:error] = "Invalid URL."
      redirect_to :action => 'index'
    end
  end
  
  # Route: /database_updates (POST)
  # Purpose: receives an uploaded spreadsheet, saves it to disk, 
  #          and creates a new instance of DatabaseUpdate.
  def create
    # Create the spreadsheet file in /tmp and write the file's contents to it
    filename = "#{DateTime.now.strftime("%Y%m%d%H%M%S")}_sheet.xls"
    data = params[:file].read
    spreadsheet_file = File.new("#{RAILS_ROOT}/tmp/#{filename}", 'w+')
    spreadsheet_file.write(data)
    spreadsheet_file.close
    
    begin
      # Create a new instance of DatabaseUpdate for this spreadsheet. 
      # NOTE: All the work of running the update on the database is handled
      #       inside the DatabaseUpdate class on its first instantiation. i.e., upon create.
      @dbup = DatabaseUpdate.create(:spreadsheet_path => spreadsheet_file.path)
    rescue CallLogExceptions::InvalidSpreadsheetError
      # DatabaseUpdate has thrown an error related to the format of the spreadsheet. Alert the user.
      flash[:error] = "<strong>The spreadsheet you provided is not in the anticipated format.</strong>\nPlease correct the sheet and try again."
      redirect_to :controller => 'supervisor', :action => 'index'
    end
    redirect_to @dbup
  end
end
