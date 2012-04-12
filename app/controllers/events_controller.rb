class EventsController < ApplicationController

  layout "standard"

  # GET /events
  # GET /events.xml
  def index
    @current_user = User.find(session[:user_id])
    @events = @current_user.events
    #@events = Event.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @current_user = User.find(session[:user_id])
    @event = @current_user.events.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    @event.url = params[:event_url] unless params[:event_url].nil?
    @event.description = params[:event_description] unless params[:event_description].nil?
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @current_user = User.find(session[:user_id])
    @event = @current_user.events.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @event.update_recurrence
    @current_user = User.find(session[:user_id])
    @current_user.events <<@event 

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @current_user = User.find(session[:user_id])
    @event = @current_user.events.find(params[:id])
    @current_user.events <<@event 

    respond_to do |format|
      if @event.update_attributes(params[:event])
        @event.update_recurrence
        @event.save  
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @current_user = User.find(session[:user_id])
    @event = @current_user.events.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
end
