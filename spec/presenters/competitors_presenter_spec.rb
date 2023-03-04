# frozen_string_literal: true

require 'rails_helper'

describe CompetitorsPresenter do
  subject(:presenter) { described_class.new(competition) }

  let(:competition) { build_stubbed(:competition) }

  describe '#name' do
    context 'when name is blank' do
      let(:competition) { build_stubbed(:competition, name: '') }

      it 'fall back to NA' do
        expect(presenter.name).to eq('NA')
      end
    end

    context 'when name is present' do
      it 'returns name' do
        expect(presenter.name).to eq(competition.name)
      end
    end
  end

  describe '#logo' do
    context 'when logo is blank' do
      let(:competition) { build_stubbed(:competition, logo: '') }

      it 'return default URL' do
        expect(presenter.logo).to eq described_class::URL
      end
    end

    context 'when logo is present' do
      it 'returns logo' do
        expect(presenter.logo).to eq(competition.logo)
      end
    end
  end
end
