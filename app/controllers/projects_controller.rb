# -*- coding: utf-8 -*-
class ProjectsController < ApplicationController
  layout "streets"

  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    authenticate_user!
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    authenticate_user!
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    authenticate_user!
    @project = Project.new(params[:project].merge({:users => [login_user]}))
    @project.users << login_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    authenticate_user!
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(@project, :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    authenticate_user!
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  #################### application methods ###################

  def add_me
    authenticate_user!
    @project = Project.find(params[:id])
    @project.users << login_user
    redirect_to(@project, :notice => "プロジェクトに参加しました！")    
  end

  def delete_me
    authenticate_user!
    @project = Project.find(params[:id])
    
    @project.steps.each do |step|
      step.user = nil if step.user == login_user
      step.person_in_charge = nil if step.person_in_charge == login_user 
      step.save
    end

    @project.users.delete(login_user)

    @project.steps.each {|step|
      if step.user and step.user == login_user 
        step.user = nil 
        step.save
      end
    }

    @project.save
    redirect_to(@project, :notice => "プロジェクトへの参加を取り消しました。")    
  end

  def detail
    authenticate_user!
    @project = Project.find(params[:id])

    render
  end

  def detail_edit
    authenticate_user!
    @project = Project.find(params[:id])

    render
  end

  def detail_save
    authenticate_user!
    @project = Project.find(params[:id])
    result = @project.update_attributes(params[:project])

    respond_to do |format|
      if result
        format.html { redirect_to({:action => :detail, :id => @project.id}, 
                            :notice => 'Project was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def watch
    authenticate_user!
    @project = Project.find(params[:id])
    result = @project.watchers << login_user

    respond_to do |format|
      if result
        format.html { redirect_to(@project, 
                                  :notice => 'This project is watching.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

end
