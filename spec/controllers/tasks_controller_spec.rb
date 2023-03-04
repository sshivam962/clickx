# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:business) { create(:business) }

  shared_examples 'access to tasks' do
    describe 'GET #index' do
      it 'responds successfully with list of tasks' do
        4.times do
          create(:task)
        end
        get :index, params: { business_id: @biz.id }
        expect(response).to be_success
        expect(JSON.parse(response.body).count).to eq(Task.all.count)
      end
    end
    describe 'GET #show' do
      it 'responds successfully with task' do
        task = create(:task)
        get :show, params: { business_id: @biz.id, id: task.id }
        expect(response).to be_success
        expect(JSON.parse(response.body)['id']).to eq(task.id)
      end
    end
    describe 'DELETE #destroy' do
      it 'responds successfully and task should be deleted' do
        task = create(:task)
        delete :destroy, params: { business_id: @biz.id, id: task.id }
        expect(response).to be_success
        expect(Task.where(id: task.id).count).to eq(0)
      end
    end
    describe 'POST #create' do
      it 'responds successfully and task should be created' do
        fake_name = Faker::Company.name
        create_params = { 'task' => { 'task_type' => 'Off-Site SEO', 'sub_tasks' => %w[AAA BBB] }, 'business_id' => @biz.id }
        post :create, params: create_params
        expect(Task.all.count).to eq(1)
        expect(Task.all.last.sub_tasks.count).to eq(2)
      end
      it 'responds with error and task should not be created when validation fails' do
        create_params = { 'task' => { 'task_type' => '', 'sub_tasks' => %w[AAA BBB] }, 'business_id' => @biz.id }
        post :create, params: create_params
        expect(Task.all.count).to eq(0)
        data = JSON.parse(response.body)
        expect(data['errors']['task_type']).to eq(["can't be blank"])
      end
    end
    describe 'PUT #update' do
      xit 'responds successfully and task should be updated' do
        task = create(:task, business: business)
        new_type = 'Social Media'
        update_params = { 'task' =>
          { 'id' => task.id,
            'sub_tasks' => %w[AAA BBB CCC],
            'state' => task.state,
            'business_id' => business.id,
            'task_type' => new_type },
                          'id' => task.id }

        put :update, params: update_params
        expect(response).to be_success
        expect(Task.all.count).to eq(1)
        task.reload
        expect(task.task_type).to eq(new_type)
      end
      xit 'responds with error and task should not be updated when validation fails' do
        task = create(:task)
        update_params = { 'task' =>
          { 'id' => task.id,
            'sub_tasks' => %w[AAA BBB CCC],
            'state' => task.state,
            'business_id' => @biz.id,
            'task_type' => '' },
                          'business_id' => '1', 'id' => task.id }

        put :update, params: update_params
        expect(Task.all.count).to eq(1)
        data = JSON.parse(response.body)
        expect(data['errors']['task_type']).to eq(["can't be blank"])
      end
    end
  end

  shared_examples 'limited access to tasks' do
    describe 'GET #index' do
      it 'responds unsuccessfully with list of tasks' do
        4.times do
          create(:task)
        end
        get :index, params: { business_id: @biz.id }
        expect(response).not_to be_success
        expect(response).to have_http_status(302)
      end
    end
    describe 'GET #show' do
      it 'responds unsuccessfully with task' do
        task = create(:task)
        get :show, params: { business_id: @biz.id, id: task.id }
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
      end
    end
    describe 'DELETE #destroy' do
      it 'responds unsuccessfully and task should not be deleted' do
        task = create(:task)
        delete :destroy, params: { business_id: @biz.id, id: task.id }
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
      end
    end
    describe 'POST #create' do
      it 'responds unsuccessfully and task should not be created' do
        fake_name = Faker::Company.name
        create_params = { 'task' => { 'task_type' => 'Off-Site SEO', 'sub_tasks' => %w[AAA BBB] }, 'business_id' => @biz.id }
        post :create, params: create_params
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
      end
      it 'responds with error and task should not be created when validation fails' do
        create_params = { 'task' => { 'task_type' => '', 'sub_tasks' => %w[AAA BBB] }, 'business_id' => @biz.id }
        post :create, params: create_params
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
      end
    end
    describe 'PUT #update' do
      xit 'responds successfully and task should be updated' do
        task = create(:task)
        new_type = 'Social Media'
        old_type = task.task_type
        update_params = { 'task' =>
          { 'id' => task.id,
            'sub_tasks' => %w[AAA BBB CCC],
            'state' => task.state,
            'business_id' => @biz.id,
            'task_type' => new_type },
                          'business_id' => '1', 'id' => task.id }

        put :update, params: update_params
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
        expect(task.task_type).to eq(old_type)
      end
      xit 'responds with error and task should not be updated when validation fails' do
        task = create(:task)
        update_params = { 'task' =>
          { 'id' => task.id,
            'sub_tasks' => %w[AAA BBB CCC],
            'state' => task.state,
            'business_id' => @biz.id,
            'task_type' => '' },
                          'business_id' => '1', 'id' => task.id }

        put :update, params: update_params
        expect(response).not_to be_success
        expect(response).to have_http_status(406)
      end
    end
  end

  context 'when super admin signed in' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = create(:super_admin)
      sign_in @user
      @biz = create(:business)
    end
    include_examples 'access to tasks'
  end

  context 'when company user signed in' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = create(:company_admin)
      @biz = create(:business)
      @user.update(ownable: @biz)
      sign_in @user
    end
    include_examples 'limited access to tasks'
  end
end
