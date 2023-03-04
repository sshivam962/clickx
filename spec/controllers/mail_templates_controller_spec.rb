# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailTemplatesController, type: :controller do
  context 'when super admin signed in' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = create(:super_admin)
      sign_in @user
    end
    describe 'GET #index' do
      it 'responds successfully with list of templates' do
        create(:mail_template)
        create(:new_comment_mail_template)
        create(:content_feedback_mail_template)

        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(MailTemplate.all.count)
      end
    end
    describe 'GET #show' do
      it 'responds successfully with mail template' do
        mail = create(:mail_template)
        get :show, params: { id: mail.id }
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(mail.id)
      end
    end
    describe 'GET #edit' do
      it 'responds successfully with mail template' do
        mail = create(:mail_template)
        get :edit, params: { id: mail.id }
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq(mail.id)
      end
    end

    describe 'PUT #update' do
      it 'responds successfully and agency should be updated' do
        template = create(:mail_template)
        test_subject = 'test subject for template'
        update_params = { 'mail' =>
                         { 'subject' => test_subject,
                           'id' => template.id }, 'id' => template.id }
        put :update, params: update_params
        expect(response).to be_success
        expect(MailTemplate.find(template.id).subject).to eq(test_subject)
      end
      it 'responds with error and agency should not be updated when validation fails' do
        template = create(:mail_template)
        test_subject = ''
        update_params = { 'mail' =>
                         { 'subject' => test_subject,
                           'id' => template.id }, 'id' => template.id }
        put :update, params: update_params
        data = JSON.parse(response.body)
        expect(data['errors']['subject']).to eq(["can't be blank"])
      end
    end
  end
end
