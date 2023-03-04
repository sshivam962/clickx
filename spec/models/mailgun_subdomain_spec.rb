require 'rails_helper'

RSpec.describe MailgunSubdomain, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:subdomain) }
    it { should validate_presence_of(:user_name) }
    it { should validate_presence_of(:password) }
  end
end
