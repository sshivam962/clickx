# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StateTracker, type: :model do
  it 'is invalid without a transition date' do
    expect(build(:state_tracker, transition_date: nil)).not_to be_valid
  end

  it 'is valid with a transition date' do
    expect(build(:state_tracker)).to be_valid
  end

  it 'is invalid without from state' do
    expect(build(:state_tracker, from_state: nil)).not_to be_valid
  end

  it 'is invalid if from_state not amongst the ContentStates and shows error message' do
    @foo = create(:state_tracker)
    @foo.from_state = 'false state'
    expect(@foo).not_to be_valid
    expect(@foo.errors.messages[:from_state].last).to eq('not a valid state')
  end

  it 'is invalid without to state and shows error message' do
    expect(build(:state_tracker, to_state: nil)).not_to be_valid
  end

  it 'is invalid if to_state not amongst the ContentStates and shows error message' do
    @foo = create(:state_tracker)
    @foo.to_state = 'false state'
    expect(@foo).not_to be_valid
    expect(@foo.errors.messages[:to_state].last).to eq('not a valid state')
  end
end
