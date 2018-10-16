# Preview all emails at http://localhost:3000/rails/mailers/report_mailer
class ReportMailerPreview < ActionMailer::Preview
  def report_email
    report = Report.last
    ReportMailer.report_email(report)
  end
end
