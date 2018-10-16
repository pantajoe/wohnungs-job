class ReportsController < ApplicationController
  include Chartable

  before_action :load_project
  before_action :load_months, only: :index

  def index
    @reports = @project.reports.where(month: @month).order(created_on: :desc)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @report = @project.reports.new(reports_params)
    @performances = PerformanceData.new(@project.id, @report.month)
    set_chart_variables
    @report.created_on = Time.now.to_datetime
    @report.file = PdfRenderer.new(@report).pdf_for_report
    @report.save

    @reports = @project.reports.where(month: @report.month).order(created_on: :desc)

    respond_to do |format|
      format.js
    end
  end

  def show
    @report = @project.reports.find(params[:id])

    send_data @report.file,
              filename: 'report.pdf',
              disposition: 'inline',
              type: 'application/pdf'
  end

  def preview
    @report = @project.reports.new(month: Date.today)
    @performances = PerformanceData.new(@project.id, @report.month)
    set_chart_variables

    # respond_to do |format|
    #   format.pdf do
    #     render pdf: "Report",
    #       template: 'reports/show.html.haml',
    #       layout: 'report.html.haml',
    #       show_as_html: params.key?('debug'),
    #       encoding: "UTF-8",
    #       page_size: 'A4',
    #       page_width: 213,
    #       page_height: 297,
    #       background: true,
    #       header: {
    #         html: {
    #           template: 'reports/show.html.haml',
    #           layout: 'report_head.html.haml'
    #         },
    #         spacing: 16
    #       },
    #       margin: {
    #         bottom: 0,
    #         left: 0,
    #         right: 0
    #       },
    #       javascript_delay: 500
    #   end
    # end

    @report.file = PdfRenderer.new(@report).pdf_for_report
    send_data @report.file,
              filename: 'report.pdf',
              disposition: 'inline',
              type: 'application/pdf'
  end

  def send_mail
    @report = @project.reports.find(params[:id])

    ReportMailer.report_email(@report).deliver_now
    flash[:notice] = t('.success', month: month_for_report(@report),
                                   customer: @project.customer)

    respond_to do |format|
      format.js
    end
  end

  private

  def reports_params
    params.require(:report).permit(:month)
  end

  def load_project
    @project = Project.find(params[:project_id])
  end

  def load_months
    all_months = @project.reports.order(month: :desc).distinct.pluck(:month)
    all_months.insert(0, Date.today.beginning_of_month) unless all_months.include?(Date.today.beginning_of_month)

    # pass allowed_months to JS
    gon.allowed_months = all_months.map {|month| month.strftime('%Y-%m-%d') }

    @month =
      begin
        Date.parse(params[:month]).beginning_of_month
      rescue TypeError, ArgumentError
        all_months.first || Date.today.beginning_of_month
      end

    index = all_months.index(@month) || 0

    @months = if index == 0
                all_months.first(3)
              elsif index == (all_months.size - 1)
                all_months.last(3)
              else
                all_months[(index - 1)..(index + 1)]
              end
  end

  def month_for_report(report)
    I18n.l(report.month, format: :monthyearshort)
  end

  def set_chart_variables
    super
    gon.last_day_of_month = @report.month.end_of_month.day
    gon.month_name = ". #{l(@report.month, format: :month)}"
  end
end
