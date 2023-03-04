# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AgenciesController, type: :controller do
  context 'when super admin signed in' do
    login_super_admin
    xdescribe 'GET #index' do
      it 'responds successfully with list of agencies' do
        4.times do
          create(:agency)
        end
        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['agency'].count).to eq(Agency.all.count)
      end
    end
    describe 'GET #show' do
      it 'responds successfully with agency' do
        agency = create(:agency)
        get :show, params: { id: agency.id }
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(agency.id)
      end
    end
    describe 'GET #edit' do
      it 'responds successfully with agency' do
        agency = create(:agency)
        get :edit, params: { id: agency.id }
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(agency.id)
      end
    end
    describe 'DELETE #destroy' do
      it 'responds successfully and agency should be deleted' do
        agency = create(:agency)
        delete :destroy, params: { id: agency.id }
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(Agency.where(id: agency.id).count).to eq(0)
      end
    end
    describe 'POST #create' do
      it 'responds successfully and agency should be created' do
        fake_name = Faker::Company.name
        create_params = { 'agency' =>
                         { 'name' => fake_name,
                           'support_email' => Faker::Internet.email('clickx'),
                           'address' => Faker::Address.street_address,
                           'phone' => Faker::PhoneNumber.phone_number } }
        post :create, params: create_params
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(Agency.where(name: fake_name).count).to eq(1)
      end
      it 'responds with error and agency should not be created when validation fails' do
        fake_email = Faker::Internet.email('clickx')
        create_params = { 'agency' =>
                         { 'name' => '',
                           'support_email' => Faker::Internet.email('clickx'),
                           'address' => Faker::Address.street_address,
                           'phone' => Faker::PhoneNumber.phone_number } }
        post :create, params: create_params
        expect(Agency.where(support_email: fake_email).count).to eq(0)
        data = JSON.parse(response.body)
        expect(data['errors']['name']).to eq(["can't be blank"])
      end
    end
    describe 'PUT #update' do
      it 'responds successfully and agency should be updated' do
        agency = create(:agency)
        fake_name = agency.name
        new_name = 'test agency'
        update_params = { 'agency' =>
                         { 'name' => new_name,
                           'id' => agency.id }, 'id' => agency.id }
        put :update, params: update_params
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(Agency.where(name: fake_name).count).to eq(0)
        expect(Agency.where(name: new_name).count).to eq(1)
      end
      it 'responds with error and agency should not be updated when validation fails' do
        agency = create(:agency)
        fake_email = Faker::Internet.email('clickx')
        update_params = { 'agency' =>
                         { 'name' => '',
                           'support_email' => fake_email,
                           'id' => agency.id }, 'id' => agency.id }
        put :update, params: update_params
        expect(Agency.where(support_email: fake_email).count).to eq(0)
        data = JSON.parse(response.body)
        expect(data['message']).to eq("Name can't be blank")
      end
    end
  end

  context 'when user other than super admin signed in' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = create(:user)
      sign_in @user
    end
    describe 'GET #index' do
      it 'responds with error without list of agencies' do
        4.times do
          create(:agency)
        end
        get :index
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
      end
    end
    describe 'GET #show' do
      it 'responds with error' do
        agency = create(:agency)
        get :show, params: { id: agency.id }
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
      end
    end
    describe 'GET #edit' do
      it 'responds with error' do
        agency = create(:agency)
        get :edit, params: { id: agency.id }
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
      end
    end
    describe 'DELETE #destroy' do
      it 'responds with error and agency should be deleted' do
        agency = create(:agency)
        delete :destroy, params: { id: agency.id }
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
        expect(Agency.where(id: agency.id).count).to eq(1)
      end
    end
    describe 'POST #create' do
      it 'responds with error and agency should not be created' do
        fake_name = Faker::Company.name
        create_params = { 'agency' =>
                         { 'name' => fake_name,
                           'support_email' => Faker::Internet.email('clickx'),
                           'address' => Faker::Address.street_address,
                           'phone' => Faker::PhoneNumber.phone_number } }
        post :create, params: create_params
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
        expect(Agency.where(name: fake_name).count).to eq(0)
      end
    end
    describe 'PUT #update' do
      it 'responds with error and agency not should be updated' do
        agency = create(:agency)
        fake_name = agency.name
        new_name = 'test agency'
        update_params = { 'agency' =>
                         { 'name' => new_name,
                           'id' => agency.id }, 'id' => agency.id }
        put :update, params: update_params
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
        expect(Agency.where(name: fake_name).count).to eq(1)
        expect(Agency.where(name: new_name).count).to eq(0)
      end
    end
  end
end
