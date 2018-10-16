require 'rails_helper'

RSpec.describe 'managing Incidents' do
  before :each do
    @project1 = Project.create! title: 'Test Projekt', repo_name: 'test-project', appsignal_id: '1A2B3C4D5C6E7F', customer: 'Herr Baum', email: 'test@example.com'
  end

  specify 'show incident' do
    skip
    @incident1 = @project1.incidents.create! time_from: '2017-09-04 10:39:41', time_to: '2017-09-04 11:13:27', what_happened: 'Absturz', which_server: 'Datenbank'
    visit project_url(@project1)
    click_on(class: 'incidents-tab')
    click_on(class: 'show-incident')
    expect(page).to have_content('04.09.2017 10:39 - 11:13')
    expect(page).to have_content('11:13')
    expect(page).to have_content('Was ist passiert?')
    expect(page).to have_content('Absturz')
    expect(page).to have_content('Welcher Server war betroffen?')
    expect(page).to have_content('Datenbank')
    expect(page).to have_content('Wie haben wir von dem Problem erfahren?')
    expect(page).to have_content('Was haben wir getan?')
    expect(page).to have_content('Welche weiteren Auswirkungen gab es?')
    expect(page).to have_content('Was tun wir, um ähnliche Probleme künftig zu verhindern?')
  end

  specify 'change what_happened' do
    skip
    @incident1 = @project1.incidents.create! time_from: '2017-09-04 10:39:41', time_to: '2017-09-04 11:13:27', what_happened: 'Absturz', which_server: 'Datenbank'
    visit project_url(@project1)
    click_on(class: 'incidents-tab')
    click_on(class: 'show-incident')
    click_on(class: 'edit-post-mortem')
    fill_in 'Was ist passiert?', with: 'Testfehler'
    click_on 'Speichern'
    click_on 'Zurück'
    expect(page).to have_content('Was ist passiert?')
    expect(page).to have_content('10:39')
    expect(page).to have_content('11:13')
    expect(page).to have_content('Testfehler')
    expect(page).to have_content('Datenbank')
  end

  specify 'create a postmortem' do
    skip
    @incident2 = @project1.incidents.new(time_from: '2017-09-04 10:39:41', time_to: '2017-09-04 11:13:27')
    @incident2.save(validate: false)
    visit project_url(@project1)
    click_on(class: 'incidents-tab')
    click_on(class: 'show-incident')
    click_on(class: 'new-post-mortem')
    fill_in 'Was ist passiert?', with: 'Test case'
    fill_in 'Welcher Server war betroffen?', with: 'testserver'
    click_on 'Speichern'
    expect(page).to have_content('testserver')
    expect(page).to have_content('Test case')
    click_on 'Zurück'
    expect(page).to have_content('testserver')
    expect(page).to have_content('Test case')
  end
end
