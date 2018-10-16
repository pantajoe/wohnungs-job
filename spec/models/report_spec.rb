require 'rails_helper'

RSpec.describe Report, type: :model do
  before :each do
    @project1 = Project.create! title: 'Projekt 4', repo_name: 'project4', appsignal_id: '1A2B3C4D5C6E7F', customer: 'Herr Baum', email: 'Zweitag@zweitag.de'
    @incident1 = @project1.incidents.create! time_from: '2017-08-04 10:00:00', time_to: '2017-08-04 11:00:00', what_happened: 'Absturz2', which_server: 'Datenbank2'
    @incident2 = @project1.incidents.create! time_from: '2016-04-01 00:00:00', time_to: '2016-04-30 23:59:59', what_happened: 'Absturz3', which_server: 'Datenbank3'
    @sentry_error1 = @project1.sentry_errors.create! day: '2017-09-01', number_of_events: '19', repo_name: 'project4'
    @sentry_error2 = @project1.sentry_errors.create! day: '2017-10-01', number_of_events: '3', repo_name: 'project4'
  end

  it 'selects the incidents of the given month' do
    report = @project1.reports.new
    report.month = '2017-08-01'
    expect(report.availability.round(2)).to eq(99.87)
  end

  it 'without incidents' do
    report = @project1.reports.new
    report.month = '2017-07-01'
    expect(report.availability.round(2)).to eq(100.0)
  end

  it 'with an incident spanning the whole month' do
    report = @project1.reports.new
    report.month = '2016-04-01'
    expect(report.availability.round(2)).to eq(0.0)
  end

  it 'do not generate 2 reports in one month automatically' do
    report = @project1.reports.new
    report.month = Date.new(2017, 9, 1)
    report.created_on = Date.new(2017, 9, 1)
    report.file = PdfRenderer.new(report).pdf_for_report
    report.save
    GenerateReportsJob.new.generate_reports(Date.new(2017, 9, 1))
    GenerateReportsJob.new.generate_reports(Date.new(2017, 10, 1))

    expect(Report.all.count).to eq(2)
    expect(Report.where(month: Date.new(2017, 9, 1)).count).to eq(1)
    expect(Report.where(month: Date.new(2017, 10, 1)).count).to eq(1)
  end
  # it 'with two default incidents'
  # it 'with two overlapping incidents'
end
