# frozen_string_literal: true

module Features
  def sign_in_with(email, password)
    visit new_user_session_path
    fill_in 'user[login]', with: email
    fill_in 'user[password]', with: password
    click_button 'Sign in to My Account'
  end
end
