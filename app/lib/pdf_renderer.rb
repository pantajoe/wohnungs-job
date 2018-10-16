class PdfRenderer
  attr_accessor :report

  def initialize(report)
    @report = report
  end

  def pdf_for_report
    WickedPdf.new.pdf_from_string(
      html_string,
      margin: {
        bottom: 0,
        left: 0,
        right: 0
      },
      page_width: 213,
      page_height: 297,
      header: {
        content: header_string,
        spacing: 20
      },
      javascript_delay: 500,
      print_media_type: true,
      page_size: 'A4',
      encoding: 'UTF-8',
      background: true
    )
  end

  private

  def local_variables
    {
      report: @report,
      project: @report.project,
      code_cares: @report.project.code_cares.where.not(enddate: nil),
      performances: PerformanceData.new(@report.project.id, @report.month)
    }
  end

  def html_string
    render_with_layout 'report.html.haml'
  end

  def header_string
    render_with_layout 'report_head.html.haml'
  end

  def render_with_layout(layout)
    ApplicationController.render('reports/show.html.haml',
                                 assigns: local_variables,
                                 layout: layout)
  end
end
