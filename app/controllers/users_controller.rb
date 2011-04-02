class UsersController < ApplicationController
  layout "streets"
  before_filter :authenticate_user!
  
  # GET /projects
  # GET /projects.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end


  # GET /projects/1
  # GET /projects/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /projects/1/edit
  def edit
    authenticate_user!

    if @user != login_user
      raise UnAuthorized.new
    end

    @user = User.find(params[:id])
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    authenticate_user!
    @user = User.find(params[:id])

    if @user != login_user
      raise UnAuthorized.new
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def followers
    authenticate_user!
    user = User.find(params[:id])
    @users = user.followers

    respond_to do |format|
      format.html { render :index } # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def friends
    authenticate_user!
    user = User.find(params[:id])
    @users = user.friends

    respond_to do |format|
      format.html { render :index } # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

end
