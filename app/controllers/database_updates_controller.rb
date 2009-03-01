class DatabaseUpdatesController < ApplicationController
  def index
  end

  def show
    begin
      @update = DatabaseUpdate.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      #flash[:error] = "Invalid URL."
      redirect_to :action => 'index'
    end
  end

  def new
  end

  def create
    # Create the spreadsheet file in /tmp and write the file's contents to it
    filename = "#{DateTime.now.strftime("%Y%m%d%H%M%S")}_sheet.xls"
    data = params[:file].read
    spreadsheet_file = File.new("#{RAILS_ROOT}/tmp/#{filename}", 'w+')
    spreadsheet_file.write(data)
    spreadsheet_file.close
    
    begin
      @dbup = DatabaseUpdate.create(:spreadsheet_path => spreadsheet_file.path)
    rescue CallLogExceptions::InvalidSpreadsheetError
      flash[:error] = "The spreadsheet you provided is not in the anticipated format.\nPlease correct the sheet and try again."
      redirect_to :controller => 'supervisor', :action => 'index'
    end
    redirect_to @dbup
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end 
end
