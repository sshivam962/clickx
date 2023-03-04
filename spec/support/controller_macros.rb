# frozen_string_literal: true

module ControllerMacros
  def login_super_admin
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in FactoryBot.create(:super_admin)
    end
  end

  def login_company_admin
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:company_admin)
      @business = FactoryBot.create(:business)
      user.update(ownable: @business)
      sign_in user
      cookies[:current_business_id] = user.ownable_id
    end
  end

  def login_user
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user)
      user.confirm!
      sign_in user
    end
  end
end
