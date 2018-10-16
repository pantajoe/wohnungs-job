class SecuritiesController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @code_cares = @project.code_cares.order(startdate: :asc)
  end
end
