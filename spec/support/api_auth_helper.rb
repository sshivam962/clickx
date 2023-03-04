# frozen_string_literal: true

module ApiAuthHelper
  def sign_in_api(user)
    request.header('X-USER-TOKEN', user.token)
  end

  def create_and_sign_in_user
    user = FactoryBot.create(:user)
    sign_in(user)
    user
  end

  alias create_and_sign_in_another_user create_and_sign_in_user

  def create_and_sign_in_company_admin
    admin = FactoryBot.create(:company_admin)
    sign_in(admin)
    admin
  end

  def create_and_sign_in_super_admin
    admin = FactoryBot.create(:super_admin)
    sign_in(admin)
    admin
  end
end
