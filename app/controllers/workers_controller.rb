class WorkersController < ApplicationController
  # GET /workers
  # GET /workers.xml
  def index
    @workers = Worker.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @workers }
    end
  end

  # GET /workers/1
  # GET /workers/1.xml
  def show
    @worker = Worker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @worker }
    end
  end

  # GET /workers/new
  # GET /workers/new.xml
  def new
    @worker = Worker.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @worker }
    end
  end

  # GET /workers/1/edit
  def edit
    @worker = Worker.find(params[:id])
  end

  # POST /workers
  # POST /workers.xml
  def create
    @worker = Worker.new(params[:worker])

    respond_to do |format|
      if @worker.save
        flash[:notice] = 'Worker was successfully created.'
        format.html { redirect_to(@worker) }
        format.xml  { render :xml => @worker, :status => :created, :location => @worker }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @worker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /workers/1
  # PUT /workers/1.xml
  def update
    @worker = Worker.find(params[:id])

    respond_to do |format|
      if @worker.update_attributes(params[:worker])
        flash[:notice] = 'Worker was successfully updated.'
        format.html { redirect_to(@worker) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @worker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /workers/1
  # DELETE /workers/1.xml
  def destroy
    @worker = Worker.find(params[:id])
    @worker.destroy

    respond_to do |format|
      format.html { redirect_to(workers_url) }
      format.xml  { head :ok }
    end
  end
end
