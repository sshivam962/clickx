# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BusinessesController, type: :controller do
  shared_examples 'access individual business view' do
    describe 'GET #show' do
      it 'responds successfully with business' do
        biz = create(:business)
        get :show, params: { id: biz.id }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(biz.id)
      end
    end
  end

  describe 'GET business_keywords' do
    let(:business) { create(:business) }
    let(:user) { create(:company_admin, ownable: business) }
    let(:keyword) { create(:keyword, :with_keyword_tags, business: business) }
    let(:tags) { keyword.keyword_tags }

    before do
      sign_in user
    end

    context 'when GET business keywords' do
      before do
        KeywordRanking.create(keyword_id: keyword.id)
        get :business_keywords, params: { id: business.id }
      end
      it 'has an array of keywords' do
        expect(JSON.parse(response.body)['data']).not_to be_empty
      end
      it 'has keywords where each keyword has an array of tags' do
        expect(JSON.parse(response.body)['data'][0]['tags']).not_to be_empty
      end
      it 'has tags with correct tag name' do
        expect(JSON.parse(response.body)['data'][0]['tags'][0]['name']).to eq(tags[0].name)
      end
      it 'has tags with correct tag color' do
        expect(JSON.parse(response.body)['data'][0]['tags'][0]['color']).to eq(tags[0].color)
      end
      it 'has tags with correct tag id' do
        expect(JSON.parse(response.body)['data'][0]['tags'][0]['id']).to eq(tags[0].id)
      end
    end
  end

  shared_examples 'access individual created business info' do
    include_examples 'access individual business view'
    describe 'GET #edit' do
      it 'returns business' do
        biz = create(:business)
        get :edit, params: { id: biz.id }
        expect(JSON.parse(response.body)['id']).to eq(biz.id)
      end
    end
    describe 'PUT #update' do
      it 'is updated' do
        business = create(:business)
        fake_name = business.name
        new_name = 'test business'
        update_params = { 'business' =>
                         { 'name' => new_name,
                           'id' => business.id }, 'id' => business.id }
        put :update, params: update_params
        expect(Business.where(name: fake_name).count).to eq(0)
        expect(Business.where(name: new_name).count).to eq(1)
      end
      it 'is not updated' do
        business = create(:business)
        fake_name = business.name
        update_params = { 'business' =>
                         { 'name' => '',
                           'id' => business.id }, 'id' => business.id }
        put :update, params: update_params
        expect(Business.where(name: fake_name).count).to eq(1)
        data = JSON.parse(response.body)
        expect(data['errors']['name']).to eq(["can't be blank"])
      end
    end
  end

  shared_examples 'should not be able to access index, create, destroy, update' do
    describe 'GET #index' do
      it 'responds without list of businesses' do
        4.times do
          create(:business)
        end
        get :index
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
      end
    end
    describe 'DELETE #destroy' do
      it 'is not deleted' do
        biz = create(:business)
        delete :destroy, params: { id: biz.id }
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
        expect(Business.where(id: biz.id).count).to eq(1)
      end
    end
    describe 'POST #create' do
      it 'is not created' do
        agency = create(:agency)
        fake_name = Faker::Company.name
        create_params = { 'business' =>
                         {
                           'name' => fake_name, 'agency_id' => agency.id,
                           'local_profile_service' => false,
                           'seo_service' => false,
                           'call_analytics_service' => false,
                           'call_analytics_id' => '',
                           'contents_service' => false,
                           'trial_service' => false,
                           'trial_expiry_date' => { 'startDate' => '2015-10-26T07:28:33.533Z', 'endDate' => '2015-10-26T07:28:33.533Z' },
                           'users' => [{ 'email' => '', 'first_name' => '', 'last_name' => '', 'role' => '' }]
                         } }
        post :create, params: create_params
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
        expect(Business.where(name: fake_name).count).to eq(0)
      end
      describe 'PUT #update' do
        it 'is not updated' do
          business = create(:business)
          fake_name = business.name
          new_name = 'test business'
          update_params = { 'business' =>
                           { 'name' => new_name,
                             'id' => business.id }, 'id' => business.id }
          put :update, params: update_params
          expect(response).not_to be_success
          expect(response).to have_http_status(406)
          expect(Business.where(name: fake_name).count).to eq(1)
          expect(Business.where(name: new_name).count).to eq(0)
        end
      end
      #     context "call analytics" do
      #       before(:each) do
      #         @call_analytics_id = 'Ch4Nmld2htIOBwCv'
      #         @call_id = 'Ch6WElic6t5lCHj-'
      #       end
      #
      #       it "should list calls, GET #get_calls" do
      #         stub_request(:post, "https://marchexapi%40oneims.com:MyXVzc7lB1@userapi.voicestar.com/api/jsonrpc/1").
      #           with(:body => "{\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"call.search\",\"params\":[\"Ch4Nmld2htIOBwCv\",{\"extended\":true}]}",
      #             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
      #           to_return(:status => 200, :body => File.new("#{Rails.root}/spec/stub_responses/call_search"), :headers => {})
      #
      #         biz = create(:business, call_analytics_service: true, call_analytics_id: @call_analytics_id)
      #         get :get_calls, id: biz.id
      #         expect(JSON.parse(response.body)['business']['id']).to eq(biz.id)
      #         expect(JSON.parse(response.body)['calls'][0]['acct']).to eq(@call_analytics_id)
      #       end
      #
      #       it "should fetch call details, GET #get_call_details" do
      #         stub_request(:post, "https://marchexapi%40oneims.com:MyXVzc7lB1@userapi.voicestar.com/api/jsonrpc/1").
      #           with(:body => "{\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"call.get\",\"params\":[\"Ch6WD1Yr4ElA9MZz\"]}",
      #             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
      #           to_return(:status => 200, :body => File.new("#{Rails.root}/spec/stub_responses/call_get"), :headers => {})
      #
      #         biz = create(:business, call_analytics_service: true, call_analytics_id: @call_analytics_id)
      #         get :get_call_details, id: biz.id, call_id: @call_id
      #         expect(JSON.parse(response.body)['call_details']['call_id']).to eq(@call_id)
      #         expect(JSON.parse(response.body)['call_details']['acct']).to eq(@call_analytics_id)
      #       end
      #
      #
      #       it "should get call audio, GET #get_call_audio" do
      #         stub_request(:post, "https://marchexapi%40oneims.com:MyXVzc7lB1@userapi.voicestar.com/api/jsonrpc/1").
      #           with(:body => "{\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"call.audio.url\",\"params\":[[\"Ch6WD1Yr4ElA9MZz\"],\"mp3\"]}",
      #             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
      #           to_return(:status => 200, :body => File.new("#{Rails.root}/spec/stub_responses/call_audio"), :headers => {})
      #
      #         biz = create(:business, call_analytics_service: true, call_analytics_id: @call_analytics_id)
      #         get :get_call_audio, id: biz.id, call_id: @call_id
      #
      #         expect(JSON.parse(response.body)['call_audio'].nil?).to eq(false)
      #       end
      #     end
    end
  end

  context 'when company admin signed in' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = create(:company_admin)
      sign_in @user
    end
    # include_examples  "should not be able to access index, create, destroy, update"
    # include_examples 'access individual business view'
  end

  context 'when company user signed in' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = create(:user)
      sign_in @user
    end
    # include_examples  "should not be able to access index, create, destroy, update"
    # include_examples 'access individual business view'
  end

  context 'when super admin signed in' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = create(:super_admin)
      sign_in @user
    end
    describe 'GET #index' do
      it 'returns list of businesses' do
        4.times do
          create(:business)
        end
        get :index
        expect(JSON.parse(response.body).count).to eq(Business.all.count)
      end
    end
    describe 'DELETE #destroy' do
      it 'is deleted' do
        biz = create(:business)
        delete :destroy, params: { id: biz.id }
        expect(Business.where(id: biz.id).count).to eq(0)
      end
    end
    describe 'POST #create' do
      it 'is created' do
        agency = create(:agency)
        fake_name = Faker::Company.name
        create_params = { 'business' =>
                         {
                           'name' => fake_name, 'agency_id' => agency.id,
                           'local_profile_service' => false,
                           'seo_service' => false,
                           'call_analytics_service' => false,
                           'call_analytics_id' => '',
                           'contents_service' => false,
                           'trial_service' => false,
                           'trial_expiry_date' => { 'startDate' => '2015-10-26T07:28:33.533Z', 'endDate' => '2015-10-26T07:28:33.533Z' },
                           'users' => [{ 'email' => '', 'first_name' => '', 'last_name' => '', 'role' => '' }]
                         } }
        post :create, params: create_params
        expect(Business.where(name: fake_name).count).to eq(1)
      end
    end
    include_examples 'access individual created business info'
  end
end
