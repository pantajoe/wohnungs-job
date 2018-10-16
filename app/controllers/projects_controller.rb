class ProjectsController < ApplicationController
  include Chartable

  def index
    params[:show_archive] = false if params[:show_archive].blank?
    @projects = Project.where(archived: params[:show_archive]).order(:id)

    respond_to do |format|
      format.html
      format.js { render layout: false }
    end
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      flash[:success] = t('.success', title: @project.title)
    else
      flash[:alert] = t('.error', title: @project.title)
    end

    respond_to do |format|
      format.js { render 'create_or_update' }
    end
  end

  def show
    @project = Project.find(params[:id])
    @incidents = @project.incidents.closed.order(time_from: :desc).first(5)
    @performances = PerformanceData.new(@project.id, Date.today)
    @code_cares = @project.code_cares.order(startdate: :desc).first(5)

    set_chart_variables
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(project_params)
      flash[:success] = t('.success', title: @project.title)
    else
      flash[:alert] = t('.error', title: @project.title)
    end

    respond_to do |format|
      format.js { render 'create_or_update' }
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    flash[:notice] = t('.success', title: @project.title)

    respond_to do |format|
      format.js { render 'archive_or_destroy' }
    end
  end

  def archive
    @project = Project.find(params[:id])

    if @project.update(archived: !@project.archived?)
      flash[:notice] = t(".#{project_status}", title: @project.title)
    end

    respond_to do |format|
      format.js { render 'archive_or_destroy' }
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :repo_name, :appsignal_id, :email,
                                    :customer, :archived)
  end

  def project_status
    @project.archived? ? 'archived' : 'restored'
  end
end
