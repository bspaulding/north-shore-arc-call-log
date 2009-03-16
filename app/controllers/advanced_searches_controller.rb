# Class: AdvancedSearchesController
# Purpose: Handles CRUD for the AdvancedSearch Model.
class AdvancedSearchesController < ApplicationController
  layout 'people'
	
	before_filter :authenticate, :authorize
	
	# Constants
	FILTER_NAMES = [	"gender",
										"certifications",
										"first_name",
										"last_name",
										"nickname", 
										"address_city", 
										"address_state", 
										"address_street", 
										"address_zip", 
										"email",   
										"hired_after", 
										"hired_before", 
										"home_phone",
										"mobile_phone"]
  
  # Method: add_filter
  # Adds a filter to the search with id = params[:advanced_search_id]
  # Expects: 
  #  - params[:advanced_search_id], id of AdvancedSearch to update.
  #  - params[:new_filter_name], attribute name of AdvancedSearch to update.
  #  - params[:new_filter_value], new value for the given attribute name
  # Response:
  # Updates the page elements 'search_filters' and 'search_results'
  def add_filter
  	@advanced_search = AdvancedSearch.find(params[:advanced_search_id])
  	if params[:new_filter_name] == "certifications"
  		@certification = Certification.find(params[:new_filter_value])
  		@advanced_search.certifications << @certification
  	elsif params[:new_filter_name] == "hired_before" || params[:new_filter_name] == "hired_after"
  		date = Date.civil(	params[:new_filter_value][:"date(1i)"].to_i, 
  												params[:new_filter_value][:"date(2i)"].to_i, 
  												params[:new_filter_value][:"date(3i)"].to_i)
  		@advanced_search[params[:new_filter_name].to_sym] = date
	  	@advanced_search.save!
  	else
  		params[:new_filter_value].gsub!(/[^0-9]/, '') if params[:new_filter_name] == "home_phone" || params[:new_filter_name] == "mobile_phone"
  		
	  	@advanced_search[params[:new_filter_name].to_sym] = params[:new_filter_value]
	  	@advanced_search.save!
	  end

		@nonempty_filters = FILTER_NAMES.reject { |attr_name| @advanced_search[attr_name.to_sym].nil? unless attr_name == "certifications" } 
	 	@nonempty_filters.delete("certifications") if @advanced_search.certifications.empty?
		@empty_filters = FILTER_NAMES - @nonempty_filters
	 	@empty_filters.insert(0, "certifications") unless @advanced_search.certifications == Certification.all #=> This line isn't needed now that we're in the controller!

	  render :update do |page|
	  	page.replace_html 'search_filters', :partial => 'search_filters', :object => @advanced_search
	  	page.replace_html 'search_results', :partial => 'search_results', :object => @advanced_search.people
	  end
  end
  
  # Method: remove_filter
  # Removes a filter from the search with id = params[:advanced_search_id]
  # Expects: 
  #  - params[:advanced_search_id], id of AdvancedSearch to update.
  #  - params[:filter_name], attribute name of AdvancedSearch to update.
  # Response:
  # Updates the page elements 'search_filters' and 'search_results'
  def remove_filter
  	@advanced_search = AdvancedSearch.find(params[:advanced_search_id])
  	if params[:filter_name] == "certifications"
  		@advanced_search.certifications.delete_all
  	else
	  	@advanced_search[params[:filter_name].to_sym] = nil
	  	@advanced_search.save!
		end
  	
  	@nonempty_filters = FILTER_NAMES.reject { |attr_name| @advanced_search[attr_name.to_sym].nil? unless attr_name == "certifications" } 
	 	@nonempty_filters.delete("certifications") if @advanced_search.certifications.empty?
		@empty_filters = FILTER_NAMES - @nonempty_filters
  	
  	render :update do |page|
	  	page.replace_html 'search_filters', :partial => 'search_filters', :object => @advanced_search
	  	page.replace_html 'search_results', :partial => 'search_results', :object => @advanced_search.people
	  end
  end
  
  # Method: update_new_filter_type
  # Renders the new form for the newly selected filter type in the browser
  def update_new_filter_type
  	@advanced_search = AdvancedSearch.find(params[:advanced_search_id])
	 	
	 	render :partial => 'search_filter_form_field', :object => params[:filter_name], :locals => {:search => @advanced_search}
  end
  
  # GET /advanced_searches
  def index
    if session[:search_id]
      @advanced_search = AdvancedSearch.find(session[:search_id])
    else
      @advanced_search = AdvancedSearch.new
      @advanced_search.save!
      session[:search_id] = @advanced_search.id
    end
    redirect_to @advanced_search
  end

  # GET /advanced_searches/1
  # GET /advanced_searches/1.xml
  def show
    @advanced_search = AdvancedSearch.find(params[:id])
    @people = @advanced_search.people
    
    @nonempty_filters = FILTER_NAMES.reject { |attr_name| @advanced_search[attr_name.to_sym].nil? unless attr_name == "certifications" } 
	 	@nonempty_filters.delete("certifications") if @advanced_search.certifications.empty?
		@empty_filters = FILTER_NAMES - @nonempty_filters
	 	#@empty_filters.insert(0, "certifications") unless @advanced_search.certifications == Certification.all
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @advanced_search }
    end
  end

  # GET /advanced_searches/new
  # GET /advanced_searches/new.xml
  def new
    @advanced_search = AdvancedSearch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @advanced_search }
    end
  end

  # GET /advanced_searches/1/edit
  def edit
    @advanced_search = AdvancedSearch.find(params[:id])
  end

  # POST /advanced_searches
  # POST /advanced_searches.xml
  def create
    @advanced_search = AdvancedSearch.new(params[:advanced_search])

    respond_to do |format|
      if @advanced_search.save
        #flash[:notice] = 'AdvancedSearch was successfully created.'
        session[:advanced_search_id] = @advanced_search.id
        format.html { redirect_to(@advanced_search) }
        format.xml  { render :xml => @advanced_search, :status => :created, :location => @advanced_search }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @advanced_search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /advanced_searches/1
  # PUT /advanced_searches/1.xml
  def update
    @advanced_search = AdvancedSearch.find(params[:id])

    respond_to do |format|
      if @advanced_search.update_attributes(params[:advanced_search])
        #flash[:notice] = 'AdvancedSearch was successfully updated.'
        format.html { redirect_to(@advanced_search) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @advanced_search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /advanced_searches/1
  # DELETE /advanced_searches/1.xml
  def destroy
    @advanced_search = AdvancedSearch.find(params[:id])
    @advanced_search.destroy

    respond_to do |format|
      format.html { redirect_to(advanced_searches_url) }
      format.xml  { head :ok }
    end
  end
end
