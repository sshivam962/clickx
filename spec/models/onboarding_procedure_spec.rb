# frozen_string_literal: true
require 'rails_helper'

RSpec.describe OnboardingProcedure, type: :model do
  let(:onboarding_procedure_subject) { OnboardingProcedure.new }

  it { is_expected.to belong_to(:business) }
  it { is_expected.to belong_to(:agency) }
  it { is_expected.to have_many(:onboarding_tasks) }
  it { is_expected.to validate_uniqueness_of(:title).scoped_to(:agency_id) }

  context 'uniqueness of title when no business_id' do
    before { onboarding_procedure_subject.business_id = nil }
    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:business_id) }
  end

  it 'is invalid without title' do
    expect(build(:onboarding_procedure, title: nil)).not_to be_valid
  end

  it 'is invalid without onboarding_tasks' do
    expect(build(:onboarding_procedure)).not_to be_valid
  end

  it 'is valid with title and onboarding_tasks' do
    onboarding_procedure = build(:onboarding_procedure)
    onboarding_procedure.onboarding_tasks.push build(:onboarding_task, onboarding_procedure: onboarding_procedure)
    expect(onboarding_procedure).to be_valid
  end

  it 'return Onboarding Procedure that match templates term' do
    business_procedure = build(:onboarding_procedure)
    business_procedure.onboarding_tasks.push build(:onboarding_task, onboarding_procedure: business_procedure)
    business_procedure.save

    non_business_procedure = build(:onboarding_procedure, business: nil)
    non_business_procedure.onboarding_tasks.push build(:onboarding_task, onboarding_procedure: non_business_procedure)
    non_business_procedure.save

    expect(OnboardingProcedure.templates).to include(non_business_procedure)
    expect(OnboardingProcedure.templates).not_to include(business_procedure)
  end

  it 'return Onboarding Procedure that match assigned term' do
    business_procedure = build(:onboarding_procedure)
    business_procedure.onboarding_tasks.push build(:onboarding_task, onboarding_procedure: business_procedure)
    business_procedure.save

    non_business_procedure = build(:onboarding_procedure, business: nil)
    non_business_procedure.onboarding_tasks.push build(:onboarding_task, onboarding_procedure: non_business_procedure)
    non_business_procedure.save

    expect(OnboardingProcedure.assigned).to include(business_procedure)
    expect(OnboardingProcedure.assigned).not_to include(non_business_procedure)
  end
end
