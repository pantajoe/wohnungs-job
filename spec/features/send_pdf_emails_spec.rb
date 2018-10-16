require 'rails_helper'

RSpec.feature "SendPdfEmails", type: :feature do
  specify 'send the PDF to customer' do
    skip

    file = Rails.root.join('spec', 'fixtures', 'report.pdf').binread
    project = Project.create!(title: 'Projekt 1', repo_name: 'projekt1', appsignal_id: '1A2B3C4D5C6E7F', customer: 'Herr Baum', email: 'abc@def.de')
    report = project.reports.create!(created_on: Time.now, file: file, month: Date.parse('2017-09-15'))

    visit project_url(project)
    click_on 'Reporthistorie'
    click_on(class: 'send-report')
    mail = ActionMailer::Base.deliveries.last

    expect(mail.to).to eq(['abc@def.de'])
    expect(mail.subject).to eq('Ihr Hosting-Report für 09/2017')
    expect(mail.attachments.length).to eq(1)
    expect(mail.attachments.first.filename).to eq('report_092017.pdf')
    expect(mail.text_part.body).to include('Ihr Hosting-Report für September 2017')

    visit project_reports_path(project)
    expect(page).to have_content("Versendet")
  end
end
