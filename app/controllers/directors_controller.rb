class DirectorsController < ApplicationController
  # GET /directors
  # GET /directors.xml
  def index
    @directors = Director.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @directors }
    end
  end

  # GET /directors/1
  # GET /directors/1.xml
  def show
    @director = Director.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @director }
    end
  end

  # GET /directors/new
  # GET /directors/new.xml
  def new
    @director = Director.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @director }
    end
  end

  # GET /directors/1/edit
  def edit
    @director = Director.find(params[:id])
  end

  # POST /directors
  # POST /directors.xml
  def create
    @director = Director.new(params[:director])

    respond_to do |format|
      if @director.save
        flash[:notice] = 'Director was successfully created.'
        format.html { redirect_to(@director) }
        format.xml  { render :xml => @director, :status => :created, :location => @director }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @director.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /directors/1
  # PUT /directors/1.xml
  def update
    @director = Director.find(params[:id])

    respond_to do |format|
      if @director.update_attributes(params[:director])
        flash[:notice] = 'Director was successfully updated.'
        format.html { redirect_to(@director) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @director.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /directors/1
  # DELETE /directors/1.xml
  def destroy
    @director = Director.find(params[:id])
    @director.destroy

    respond_to do |format|
      format.html { redirect_to(directors_url) }
      format.xml  { head :ok }
    end
  end
end
