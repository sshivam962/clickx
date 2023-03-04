# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'is invalid without a comment' do
    expect(build(:comment, comment: nil)).not_to be_valid
  end

  it 'is valid with a comment' do
    expect(build(:comment)).to be_valid
  end

  it 'user should not be empty on save' do
    @foo = create(:comment)
    expect(Comment.where(user_name: '').count).to eq(0)

    @foo.update(user_name: '')
    expect(Comment.where(user_name: '').count).to eq(1)

    Comment.where(user_name: '').first
    expect(Comment.where(user_name: '').count).to eq(0)
  end

  it 'json data should have user email' do
    2.times do
      create(:comment)
    end
    comments = Comment.all.as_json
    json_keys = []
    comments.each do |cmt|
      json_keys << cmt.keys
    end
    json_keys = json_keys.flatten.compact.uniq
    %w[comment content_id user_id created_at updated_at user_name].each do |fld|
      expect(json_keys.include?(fld)).to be true
    end
    # includes user_email
    expect(json_keys.include?(:email)).to be true
  end
  # (to do : run mail_templates)
  #   it "admin should be notified for added comments" do
  #     admin = create(:admin_user)
  #     admin.invitation_accepted_at = Date.today
  #     admin.save
  #
  #     content = create(:content)
  #     create(:comment, content: content)
  #     expect(ActionMailer::Base.deliveries.last).to eq([admin.email])
  #   end
end
