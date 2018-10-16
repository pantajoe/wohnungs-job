class PerformancesController < ApplicationController
  include Chartable

  def index
    @project = Project.find(params[:project_id])
    @performances = PerformanceData.new(@project.id, Date.today)

    set_chart_variables
  end
end
