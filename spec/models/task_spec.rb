# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'has a valid factory' do
    expect(create(:task)).to be_valid
  end

  it 'has state future on create before valiation' do
    @foo = create(:task)
    expect(@foo.state).to eq('future')
  end

  context 'without state' do
    before do
      @foo = create(:task)
      @foo.state = nil
    end

    it 'is invalid after create if state in nil' do
      expect(@foo).not_to be_valid
    end

    it 'shows error message' do
      expect(@foo).not_to be_valid
      expect(@foo.errors.messages[:state].last).to eq('not a valid state')
    end

    it 'is invalid if state not amongst the taskStates' do
      @foo.state = 'false_state'
      expect(@foo).not_to be_valid
    end
  end

  it 'is invalid without a task_type' do
    expect(build(:task, task_type: nil)).not_to be_valid
  end

  it 'is valid with a state and task_type' do
    expect(build(:task)).to be_valid
  end

  context 'default scope' do
    before do
      @foo1 = create(:task)
      @foo2 = create(:task)
      @foo1.update(sub_tasks: ['hey'])
      @foo2.update(sub_tasks: ['hello'])
    end

    it 'orders by ascending name' do
      expect(Task.all).to eq([@foo2, @foo1])
    end
  end
end
