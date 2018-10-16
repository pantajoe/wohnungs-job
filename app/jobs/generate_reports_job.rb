class GenerateReportsJob < ApplicationJob
  queue_as :default

  def perform(date)
    generate_reports(date)
  end

  def generate_reports(month)
    projects = Project.not_archived
    projects.each do |project|
      next if Report.exists?(month: month, project_id: project.id)
      report = project.reports.new(month: month)
      report.created_on = Time.now.to_datetime
      report.file = PdfRenderer.new(report).pdf_for_report
      report.save
    end
  end
end
