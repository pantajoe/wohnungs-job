require 'rails_helper'

RSpec.describe 'managing projects' do
  specify 'creates a project' do
    skip
    visit(projects_index_url)
    click_on(class: 'create-project')
    fill_in 'Name', with: 'Mein Projektname'
    fill_in 'Technischer Name', with: 'Technischer Projektname'
    fill_in 'App ID', with: '1A2B3C4D5C6E7F'
    fill_in 'Ansprechpartner', with: 'Herr Ahorn Baum'
    fill_in 'E-Mail', with: 'Testkunde@example.com'
    click_on 'Speichern'
    expect(page).to have_content('Dashboard')
    expect(page).to have_content('Mein Projektname')
  end

  before :each do
    @project = Project.create! title: 'Projekt 4', repo_name: 'Manh Tin', appsignal_id: '1A2B3C4D5C6E7G', customer: 'Herr Baum', email: 'Andi@zweitag.de'
  end

  specify 'change name' do
    skip
    visit root_path
    click_on 'Anzeigen'
    click_on(class: 'edit-project')
    fill_in 'Name', with: 'Projekt 42'
    click_on 'Speichern'
    expect(page).to have_content('Dashboard')
    expect(page).to have_content('Projekt 42')
  end

  specify 'archive Project' do
    skip
    visit root_path
    click_on 'Anzeigen'
    click_on(class: 'edit-project')
    click_on 'Projekt archivieren'
    expect(page).to have_content("Projekt 'Projekt 4' wurde erfolgreich archiviert!")
    expect(page).to have_content('Projekt 4')
  end

  specify 'restore Project' do
    skip
    @project.update(archived: true)
    visit root_path
    click_on 'Anzeigen'
    click_on(class: 'edit-project')
    click_on 'Projekt wiederherstellen'
    expect(page).to have_content("Projekt 'Projekt 4' wurde erfolgreich wiederhergestellt!")
    expect(page).to have_content('Projekt 4')
    expect(page).to have_content('Dashboard')
  end

  specify 'View Project' do
    visit root_path
    click_on 'Anzeigen'
    expect(page).to have_content('Projekt 4')
  end
end
