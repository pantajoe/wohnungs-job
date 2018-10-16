class ReportMailer < ApplicationMailer
  def report_email(report)
    @report = report
    @project = report.project

    attachments["hosting-report-#{I18n.localize(report.month, format: :pdfdate)}.pdf"] = report.file
    attachments.inline['zweitag.png'] = File.read("#{Rails.root}/app/assets/images/logos/Screen/PNGs/screen--bild-wortmarke@2x.png")
    attachments.inline['availability.png'] = File.read("#{Rails.root}/app/assets/images/icons/availability.png")
    attachments.inline['incident.png'] = File.read("#{Rails.root}/app/assets/images/icons/incident.png")
    attachments.inline['code_care.png'] = File.read("#{Rails.root}/app/assets/images/icons/code_care.png")
    attachments.inline['ops_care.png'] = File.read("#{Rails.root}/app/assets/images/icons/ops_care.png")

    mail(to: @project.email, subject: "Ihr Hosting-Report für #{I18n.localize(report.month, format: :monthyearshort)}") do |format|
      format.html { render layout: 'mailer.html.haml' }
      format.text { render layout: 'mailer.text.haml' }
    end

    report.is_sent = Time.now
    report.save
  end
end
