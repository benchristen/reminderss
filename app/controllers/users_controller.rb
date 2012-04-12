class UsersController < ApplicationController

  skip_before_filter :authorize, :only => [ :new, :create ]
  before_filter :authorize_admin, :only => [ :index ]

  layout "standard"
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    unless params[:identity_url].nil?
      @user.identity_url = params[:identity_url]
    else
      redirect_to(new_session_url)
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @current_user = User.find(session[:user_id])
    if @current_user.admin?
      @user = User.find(params[:id]) 
    else
      @user = @current_user
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @current_user = User.new(params[:user])

    respond_to do |format|
      if @current_user.save
        session[:user_id] = @current_user.id if (session[:user_id] == @current_user.identity_url)
        flash[:notice] = "User #{@current_user.name} was successfully created."
        format.html { redirect_to(:controller => 'events', :action=>'index') }
        format.xml  { render :xml => @current_user, :status => :created, :location => @current_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @current_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @current_user = User.find(session[:user_id])
    @user = User.find(params[:id])    

    respond_to do |format|
      if ((@current_user.id == @user.id) or @current_user.admin?) and @user.update_attributes(params[:user])
        flash[:notice] = "User #{@user.name} was successfully updated."
        format.html { render :action=>'show' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @current_user = User.find(session[:user_id])
    @user = User.find(params[:id])    
    @user.destroy if (@current_user == @user or @current_user.admin?) 

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
