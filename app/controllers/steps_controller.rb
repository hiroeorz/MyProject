class StepsController < ApplicationController
  layout "streets"

  # GET /steps
  # GET /steps.xml
  def index
    @steps = Step.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @steps }
    end
  end

  # GET /steps/1
  # GET /steps/1.xml
  def show
    @step = Step.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/new
  # GET /steps/new.xml
  def new
    authenticate_user!
    @step = Step.new(:project_id => params[:project_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/1/edit
  def edit
    @step = Step.find(params[:id])
  end

  # POST /steps
  # POST /steps.xml
  def create
    authenticate_user!
    @step = Step.new(params[:step])

    respond_to do |format|
      if @step.save
        format.html { redirect_to(@step, :notice => 'Step was successfully created.') }
        format.xml  { render :xml => @step, :status => :created, :location => @step }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /steps/1
  # PUT /steps/1.xml
  def update
    authenticate_user!
    @step = Step.find(params[:id])

    respond_to do |format|
      if @step.update_attributes(params[:step])
        format.html { redirect_to(@step, :notice => 'Step was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /steps/1
  # DELETE /steps/1.xml
  def destroy
    authenticate_user!
    @step = Step.find(params[:id])
    @step.destroy

    respond_to do |format|
      format.html { redirect_to(steps_url) }
      format.xml  { head :ok }
    end
  end

  def close
    @step = Step.find(params[:id])
    @step.close!

    respond_to do |format|
      format.html { redirect_to(@step.project) }
      format.xml  { head :ok }
    end
  end

  def add_my_steps
    authenticate_user!
    @step = Step.find(params[:id])
    @user = login_user

    respond_to do |format|
      if @user.my_steps << @step
        format.html { redirect_to(@step.project) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@step.project) }
        format.xml  { render :xml => @step.errors }
      end
    end
  end

  def set_me
    authenticate_user!
    @step = Step.find(params[:id])
    @user = login_user

    result = true

    if login_user.step != @step
      @user.step = nil if @user.step
      @step.user = login_user
      @step.person_in_charge = login_user
      
      result = ActiveRecord::Base.transaction do
        @user.save
        @step.save
      end
    end

    respond_to do |format|
      if result
        format.html { redirect_to(@step.project) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@step.project) }
        format.xml  { render :xml => @step.errors, 
          :status => :unprocessable_entity }
      end
    end
  end

  def release
    authenticate_user!
    @step = Step.find(params[:id])
    @step.user = nil if @step.user.id == login_user.id

    respond_to do |format|
      if @step.save
        format.html { redirect_to(@step.project) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@step.project) }
        format.xml  { render :xml => @step.errors, 
          :status => :unprocessable_entity }
      end
    end
  end

  def release_charge
    authenticate_user!
    @step = Step.find(params[:id])
    @step.person_in_charge = nil if @step.person_in_charge = login_user
    @step.user = nil if @step.user == login_user

    respond_to do |format|
      if @step.save
        format.html { redirect_to(@step.project) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@step.project) }
        format.xml  { render :xml => @step.errors, 
          :status => :unprocessable_entity }
      end
    end
  end

end
