# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  context 'factory' do
    it 'has valid factory' do
      expect(build(:notification)).to be_valid
    end
  end

  context 'association' do
    it { is_expected.to  belong_to(:user) }
    it { is_expected.to  belong_to(:actor) }
    it { is_expected.to  belong_to(:target) }
  end

  context 'Instance methods' do
    let(:notification) { build(:notification) }

    context '#read' do
      it { expect(notification).not_to be_read }
      it 'return true when notification read' do
        notification.read_at = Time.now
        expect(notification).to be_read
      end
    end

    context '#actor_name' do
      it { expect(notification.actor_name).to be_blank }
    end
  end

  context 'class methods' do
    context '.read!' do
      it 'set array of notifications as set' do
        notifications = (0..5).map { create(:notification) }
        expect(notifications.first).not_to be_read # Rspec is not providing `not_to all` method
        Notification.read!(notifications.collect(&:id))
        notifications.collect(&:reload)
        expect(notifications).to all(be_read)
      end

      it 'return nil for empty arry' do
        expect(Notification.read!).to be_nil
      end
    end
  end
end
