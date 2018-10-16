class IncidentsController < ApplicationController
  before_action :load_project
  before_action :load_incident, except: :index
  before_action :load_params, only: :index

  def index
    @incidents = @project.incidents.send(params[:filter]).closed
                         .in_time_range(params[:from], params[:to])
                         .order(time_from: :desc)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show; end

  def update
    if @incident.update(incident_params)
      flash[:success] = t('.success', date: incident_date)
    else
      flash[:alert] = t('.error', date: incident_date)
    end

    respond_to do |format|
      format.js
    end
  end

  # Delete Post Mortem data
  def clear
    @incident.clear!

    flash[:alert] = t('.success', date: incident_date)

    respond_to do |format|
      format.js
    end
  end

  private

  def incident_params
    params.require(:incident).permit(:time_from, :time_to, :what_happened,
                                     :which_server, :realized_error, :solution,
                                     :impacts, :future_approach)
  end

  def incident_date
    I18n.localize(@incident.time_from, format: :dateshort)
  end

  def load_project
    @project = Project.find(params[:project_id])
  end

  def load_incident
    @incident = @project.incidents.find(params[:id])
  end

  def load_params
    params[:filter] = 'all' unless Incident::FILTER_OPTIONS
                                   .include?(params[:filter])

    params[:from] = Date.today.beginning_of_month.to_s if params[:from].blank?

    params[:to] = Date.today.end_of_month.to_s if params[:to].blank?
  end
end
