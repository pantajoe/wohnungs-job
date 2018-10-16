class DatabaseQueryController < ApplicationController
  TOKEN = 'JEqJifHLQ5qA2qvBCMlxsg'.freeze

  before_action :require_token
  before_action :load_query

  def exists
    render json: {result: @query.any?}.to_json, root: false
  end

  private

  def require_token
    return true if params[:token] == TOKEN
    render json: {errors: ['wrong token']}.to_json, root: false, status: :unprocessable_entity
    false
  end

  def load_query
    if model_and_query_present?
      @model = params[:model].classify.constantize
      id = params[:id]
      where_clause = {params[:where_attribute].to_sym => params[:where_value]}
      @query = @model.where(where_clause)
      @query = @query.where.not(id: id) if id.present?
    else
      render json: {errors: [t('.error')]}.to_json, root: false, status: :unprocessable_entity
      false
    end
  end

  def model_and_query_present?
    (params[:model].present? && params[:where_attribute].present? &&
     params[:where_value].present?)
  end
end
