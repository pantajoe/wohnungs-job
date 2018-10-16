require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe 'Get #index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
    it "loads project into @project" do
      project1 = Project.create! title: 'Projekt 4', repo_name: 'Manh Tin', appsignal_id: '1A2B3C4D5C6E7G', customer: 'Herr Baum', email: 'Zweitag@zweitag.de'
      get :index
      expect(assigns(:projects)).to eq([project1])
    end
  end
end
