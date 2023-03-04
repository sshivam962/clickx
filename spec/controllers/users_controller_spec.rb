# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'company user' do
    context 'should not access index, resend invitation, destroy & admin users' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        @user = create(:user)
        sign_in @user
      end
      describe 'GET #index' do
        it 'responds with error, without list of users' do
          get :index
          expect(response).not_to be_success
          expect(response).to have_http_status(302)
        end
      end
      describe 'GET #admin_users' do
        it 'responds with error, without list of admin users' do
          get :admin_users, params: { id: @user.id }
          expect(response).not_to be_success
          expect(response).to have_http_status(302)
        end
      end
      describe 'GET #resend_invitation' do
        it 'responds with error, without list of admin users' do
          get :resend_invitation, params: { id: @user.id }
          expect(response).not_to be_success
          expect(response).to have_http_status(302)
        end
      end
      describe 'GET #destroy' do
        it 'responds with error, without deleting user' do
          delete :destroy, params: { id: @user.id }
          expect(response).not_to be_success
          expect(response).to have_http_status(302)
          expect(User.where(id: @user.id).count).to eq(1)
        end
      end
    end
    context 'company user should be able to' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        @user = create(:user)
        4.times do
          biz = create(:business)
          biz.users << @user
        end
        sign_in @user
      end
      it 'get businesses associcated to him' do
        temp_biz = create(:business)

        get :get_businesses, params: { id: @user.id }
        resp = JSON.parse(response.body)
        expect(resp.count).to eq(@user.businesses.count)

        b_ids = []
        resp.each do |biz|
          b_ids << biz['id']
        end
        expect(b_ids.include?(temp_biz)).to eq(false)
      end
      it 'change current business' do
        new_biz = create(:business)
        get :change_current_business, params: { business_id: new_biz.id }
      end
      it 'edit profile' do
        get :edit, params: { id: @user.id }
        user = assigns[:user]
        expect(user.id).to eq(@user.id)
        expect(user.id).not_to eq(User.last.id)
      end
      it 'update profile, success' do
        new_name = Faker::Name.first_name
        update_params = { 'user' => { 'first_name' => new_name,
                                      'last_name' => @user.last_name,
                                      'phone' => @user.phone,
                                      'address' => @user.address },
                          'id' => @user.id }
        put :update, params: update_params
        expect(User.find(@user.id).first_name).to eq(new_name)
      end
      it 'update profile, failure' do
        new_name = Faker::Name.first_name
        update_params = { 'user' => { 'first_name' => '',
                                      'last_name' => '',
                                      'phone' => @user.phone,
                                      'address' => @user.address },
                          'id' => @user.id }
        put :update, params: update_params
        expect(User.find(@user.id).first_name).not_to eq(new_name)
      end
    end
  end

  context 'admin user should able to access index, resend invitation, destroy & admin users' do
    before do
      User.destroy_all
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = create(:super_admin)
      4.times do
        create(:user,
               invitation_token: Devise.token_generator.generate(User, :invitation_token)[1],
               invitation_accepted_at: nil)
      end
      sign_in @user
    end
    describe 'GET #index' do
      it 'responds with list of users' do
        get :index
        users = assigns[:users]
        # expect(users.count).to eq(User.where.not(:role => User::Admin).count)
        expect(users.count).to eq(User.count)
      end
    end
    describe 'GET #admin_users' do
      it 'responds with list of admin users' do
        get :admin_users, params: { id: @user.id }
        expect(JSON.parse(response.body).count).to eq(User.where(role: User::Admin).count)
      end
    end

    # TODO: mail templates to be created yet
    describe 'GET #resend_invitation' do
      skip 'responds with list of admin users' do
        user = User.last
        mail_template = create(:mail_template)
        mail_template.mail_type = 'Invitation'
        mail_template.save
        get :resend_invitation, params: { id: user.id }
        ActionMailer::Base.deliveries.last.to.should == [user.email]
      end
    end
    describe 'GET #destroy' do
      it 'responds with deleting user' do
        user = User.last
        delete :destroy, params: { id: user.id }
        expect(User.where(id: user.id).count).to eq(0)
      end
    end
  end
end
