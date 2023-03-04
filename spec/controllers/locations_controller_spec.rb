# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
  context 'accessing locations info' do
    before do
      mock_geocoding!

      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = create(:user)
      @business = create(:business)
      @business.users << @user
      tmp_business = create(:business)
      cookies[:current_business_id] = @business.id

      5.times do
        create(:location, business_id: @business.id)
        create(:location, business_id: tmp_business.id)
      end

      sign_in @user
    end

    describe 'GET #index' do
      it 'responds with list of locations' do
        get :index
        expect(JSON.parse(response.body).count).not_to eq(Location.all.count)
        expect(JSON.parse(response.body).count).to eq(@business.locations.count)
      end
    end

    describe 'GET #show' do
      it 'responds with location' do
        loc = @business.locations.last
        get :show, params: { id: loc.id }
        expect(JSON.parse(response.body)['id']).to eq(loc.id)
      end
    end

    describe 'GET #edit' do
      it 'responds with location' do
        loc = @business.locations.last
        get :edit, params: { id: loc.id }
        expect(JSON.parse(response.body)['id']).to eq(loc.id)
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes location' do
        loc = @business.locations.last
        delete :destroy, params: { id: loc.id }
        expect(Location.where(id: loc.id).last).to eq(nil)
      end
    end

    describe 'GET #local_profile_locations' do
      it 'retrives locations whose local profiles are added' do
        loc = @business.locations.last
        loc.local_profile_list = Faker::Company.logo
        loc.save
        get :local_profile_locations
        expect(JSON.parse(response.body).count).to eq(@business.locations.count)
        expect(JSON.parse(response.body).last['id']).to eq(loc.id)
      end

      it 'retrives locations for local profile changes' do
        loc = @business.locations.last
        get :get_service_location, params: { id: loc.id }
        expect(JSON.parse(response.body)['id']).to eq(loc.id)
      end
    end

    describe 'GET #export_csv' do
      it 'retrives locations whose local profiles are added' do
        loc = @business.locations.last
        get :export_csv, params: { id: loc.id }
        expect(response.headers['Content-Type']).to eq('text/csv')
        fname = Time.zone.now.strftime('%Y%m%d')
        expect(response.headers['Content-Disposition']).to eq("attachment; filename=\"locations_#{fname}.csv\"")
      end
    end

    describe 'PUT #update' do
      it 'is updated' do
        loc = @business.locations.last
        fake_name = loc.name
        new_name = 'new_test business'
        update_params = {
          'location' => { 'name' => new_name },
          'id' => loc.id
        }
        put :update, params: update_params
        expect(Location.where(name: fake_name).count).to eq(0)
        expect(Location.where(name: new_name).count).to eq(1)
      end
    end

    describe 'POST #create' do
      it 'is created' do
        count = @business.locations.count
        create_params = {
          'location' => {
            'name' => Faker::Company.name,
            'city' => Faker::Address.city,
            'state' => Faker::Address.state,
            'address' => Faker::Address.street_address,
            'country' => Faker::Address.country,
            'zip' => Faker::Address.zip,
            'phone' => Faker::PhoneNumber.phone_number,
            'website' => Faker::Internet.url,
            'business_id' => @business.id
          }
        }
        post :create, params: create_params
        expect(@business.locations.count).to eq(count + 1)
      end
    end
  end
end
