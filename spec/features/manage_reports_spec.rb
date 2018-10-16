require 'rails_helper'

RSpec.describe 'managing Postmortems' do
  before :each do
    allow(Date).to receive(:today).and_return(Date.parse('2017-09-04'))
    allow(Time).to receive(:now).and_return(Time.parse('2017-09-04 10:39:41'))
    @project1 = Project.create! title: 'Projekt 4', repo_name: 'project4', appsignal_id: '1A2B3C4D5C6E7F', customer: 'Herr Baum', email: 'Zweitag@zweitag.de'
    @incident1 = @project1.incidents.create! time_from: Time.now, time_to: (Time.now + 1 * 60), what_happened: 'Absturz', which_server: 'Datenbank'
    @incident2 = @project1.incidents.create! time_from: '2017-08-04 10:39:41', time_to: '2017-09-04 11:13:27', what_happened: 'Absturz2', which_server: 'Datenbank2'
    @incident3 = @project1.incidents.create! time_from: '2016-09-04 10:39:41', time_to: '2016-09-04 11:13:27', what_happened: 'Absturz3', which_server: 'Datenbank3'
    @sentry_error = @project1.sentry_errors.create! day: '2017-09-01', number_of_events: '19', repo_name: 'project4'
  end

  specify 'create pdf' do
    visit project_reports_url(@project1)
    click_on('Vorschau')

    convert_pdf_to_page

    expect(page).to have_content('Projekt 4')
    expect(page).to have_content('Absturz')
    expect(page).to have_content('Datenbank')
    expect(page).to have_no_content('Absturz3')
    expect(page).to have_no_content('Datenbank3')
  end

  def convert_pdf_to_page
    temp_pdf = Tempfile.new('pdf')
    temp_pdf << page.source.force_encoding('UTF-8')
    reader = PDF::Reader.new(temp_pdf)
    pdf_text = reader.pages.map(&:text)
    temp_pdf.close
    page.driver.response.instance_variable_set('@body', pdf_text)
  end
end
