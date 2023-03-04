# frozen_string_literal: true

require 'rails_helper'

describe ContentsPresenter do
  subject(:presenter) { described_class.new(content) }

  let(:content) { build_stubbed(:content) }

  describe '#title' do
    context 'when title is blank' do
      let(:content) { build_stubbed(:content, title: nil) }

      it 'fall back to NA' do
        expect(presenter.show_title).to eq('NA')
      end
    end

    context 'when title is present' do
      it 'returns title' do
        expect(presenter.show_title).to eq(content.title)
      end
    end
  end

  describe '#created_at' do
    context 'when created_at is present' do
      it 'returns created_at' do
        expect(presenter.created_at).to eq(content.created_at)
      end
    end
  end

  describe '#updated_at' do
    context 'when updated_at is present' do
      it 'returns updated_at' do
        expect(presenter.updated_at).to eq(content.updated_at)
      end
    end
  end

  describe '#state' do
    context 'when status is blank' do
      it 'fall back to NA' do
        expect(presenter.state).to eq('NA')
      end
    end

    context 'when status is present' do
      let(:content) { build_stubbed(:content, state: 'draft') }

      it 'returns status' do
        expect(presenter.state).to eq('draft')
      end
    end
  end
end
