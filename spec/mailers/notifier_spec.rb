# frozen_string_literal: true
require "rails_helper"

RSpec.describe Notifier, type: :mailer do
  let(:user) { create(:user) }
  let(:business) { create(:business) }
  let(:content) { create(:content, business: business) }
  let(:comment) { create(:comment, user: user, content: content) }
  let(:default_from_mail) { 'noreply@marketingportal.us' }

  describe "new_comment_from_customer" do
    let(:mail) { Notifier.new_comment_from_customer(content, comment, "admin@admin.co") }

    before do
      @new_comment_mail_template = create(:new_comment_mail_template)
    end

    it "renders the headers" do
      expect(mail.subject).to eq(@new_comment_mail_template.subject)
      expect(mail.to).to eq(['admin@admin.co'])
      expect(mail.from).to eq(['support@clickx.io'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(@new_comment_mail_template.paragraph1)
    end
  end

  describe "content_feedback_from_customer" do
    let(:mail) { Notifier.content_feedback_from_customer(content, "admin@admin.co") }

    before do
      @content_feedback_mail_template = create(:content_feedback_mail_template)
    end

    it "renders the headers" do
      expect(mail.subject).to eq(@content_feedback_mail_template.subject)
      expect(mail.to).to eq(['admin@admin.co'])
      expect(mail.from).to eq(['support@clickx.io'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(@content_feedback_mail_template.paragraph1)
    end
  end

  describe "content_submitted_to_customer" do
    let(:mail) do
      Notifier.content_submitted_to_customer(content,
                                             business.users.business_users_mailing_list.pluck(:email),
                                             business.id)
    end

    before do
      @new_content_mail_template = create(:new_content_mail_template)
    end

    it "renders the headers" do
      expect(mail.subject).to eq(@new_content_mail_template.subject)
      expect(mail.to).to eq(business.users.business_users_mailing_list.pluck(:email))
      expect(mail.from).to include(default_from_mail)
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(@new_content_mail_template.paragraph1)
    end
  end

  describe "new_reviews_email" do
    let(:review_ids) { business.reviews.where(timestamp: 24.hours.ago..Time.current).pluck(:id) }
    let(:mail) { Notifier.new_reviews_email(review_ids, 'test@test.com', business.id) }

    it "renders the headers" do
      expect(mail.subject).to eq('New Review Email')
      expect(mail.to).to eq(['test@test.com'])
      expect(mail.from).to include(default_from_mail)
    end
  end

  describe "location_info_updated" do
    let(:location) { create(:location, user: user, business: business) }
    let(:mail) { Notifier.location_info_updated(location, 'admin@admin.co', user) }

    it "renders the headers" do
      mock_geocoding! coordinates: [10, 20]
      expect(mail.subject).to eq("Location updated by #{business.name}")
      expect(mail.to).to eq(['admin@admin.co'])
      expect(mail.from).to include(default_from_mail)
    end
  end

  describe "questionnaire_answered" do
    let(:questionnaire) { create(:questionnaire, business: business) }
    let(:mail) { Notifier.questionnaire_answered(questionnaire, user) }

    before do
      user.update(invitation_accepted_at: Time.current, role: 'Admin')
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Questionnaire updated by #{questionnaire.business.name}")
      expect(mail.to).to eq(User.admins_mailing_list.pluck(:email))
      expect(mail.from).to include(default_from_mail)
    end
  end

  describe "new_content_order" do
    let(:content_order) { create(:content_order, user: user, business: business) }
    let(:mail) { Notifier.new_content_order(content_order, user) }

    before do
      user.update(invitation_accepted_at: Time.current, role: 'Admin')
    end

    it "renders the headers" do
      expect(mail.subject).to eq("New content order placed by #{content_order.business.name}")
      expect(mail.to).to eq(["support@clickx.io"])
      expect(mail.from).to include(default_from_mail)
    end
  end

  describe "content_order_approval" do
    let(:content_order) { create(:content_order, user: user, business: business) }
    let(:mail) { Notifier.content_order_approval(content_order) }

    it "renders the headers" do
      expect(mail.subject).to eq('Approve content ordered for your campaign')
      expect(mail.to).to eq([content_order.user.email])
      expect(mail.from).to include(default_from_mail)
    end
  end

  describe "weekly_mailer" do
    let(:mail) do
      Notifier.weekly_mailer(business, {}, {}, {}, {}, {}, {}, {}, ['test@test.co'])
    end

    it "renders the headers" do
      expect(mail.subject).to eq "Your weekly stats for #{business.name} 📈"
      expect(mail.to).to eq ['test@test.co']
      expect(mail.from).to include(default_from_mail)
    end
  end

  describe "weekly_mailer_summary" do
    let(:date) { Time.now.strftime("%B #{Time.now.day.ordinalize}, %Y") }
    let(:mail) { Notifier.weekly_mailer_summary({}) }

    it "renders the headers" do
      expect(mail.subject).to eq "Weekly Mailer Summary for #{date}"
      expect(mail.to).to eq ['solomon@oneims.com', 'maria@oneims.com', 'andy@oneims.com']
      expect(mail.from).to eq ['solomon@clickx.io']
    end
  end

  describe "marchex_monthly_summary" do
    let(:start_time) { Time.now.strftime("%B #{Time.now.day.ordinalize}, %Y") }
    let(:end_time) { (Time.now - 1.day).strftime("%B #{(Time.now - 1.day).day.ordinalize}, %Y") }
    let(:mail) { Notifier.marchex_monthly_summary({}, Time.now, Time.now - 1.day) }

    it "renders the headers" do
      expect(mail.subject).to eq "Monthly Call Analytics Summary for #{start_time} - #{end_time}"
      expect(mail.to).to eq ['solomon@oneims.com', 'accounts@oneims.com']
      expect(mail.from).to eq ['solomon@clickx.io']
    end
  end

  describe "reminder_email_fill_campaign_data" do
    let(:mailing_list) { build_stubbed_list(:user, 2) }
    let(:mail) { Notifier.reminder_email_fill_campaign_data(business, 'update_locaton', 'update_intelligence') }

    before do
      business.stub_chain(:users, :business_users_mailing_list)
              .and_return(mailing_list)
    end

    it "renders the headers" do
      expect(mail.subject).to eq('Update campaign details')
      expect(mail.to).to eq mailing_list.pluck(:email)
      expect(mail.from).to include(default_from_mail)
    end
  end

  describe "budget_pacing_summary_email" do
    let(:budget_pacing_biz_details) { [{ biz_name: business.name }] }

    context 'when there are no budget pacing clients' do
      it 'does not send the mail' do
        expect { Notifier.budget_pacing_summary_email([], 4, 'PPC') }
          .to change { ActionMailer::Base.deliveries.count }
          .by(0)
      end
    end

    context 'when there are budget pacing clients' do
      let(:mail) { Notifier.budget_pacing_summary_email(budget_pacing_biz_details, 4, 'PPC') }

      it "renders the headers" do
        expect(mail.subject).to eq("Display Budget Pacing - #{Date.current.strftime('%Y-%m-%d')}")
        expect(mail.to.count).to be > 0
        expect(mail.from).to eq ['support@clickx.io']
      end
    end
  end

  describe "budget_exceeded_clients_summary" do
    let(:budget_exceeded_clients) { [{ biz_name: business.name }] }

    context 'when there are no budget exceeded clients' do
      it 'does not send the mail' do
        expect { Notifier.budget_exceeded_clients_summary([], 4, 'PPC') }
          .to change { ActionMailer::Base.deliveries.count }
          .by(0)
      end
    end

    context 'when there are budget exceeded clients' do
      let(:mail) { Notifier.budget_exceeded_clients_summary(budget_exceeded_clients, 4, 'PPC') }

      it "renders the headers" do
        expect(mail.subject).to eq("Display Budget Limit Exceeded - #{Date.current.strftime('%Y-%m-%d')}")
        expect(mail.to.count).to be > 0
        expect(mail.from).to eq ['support@clickx.io']
      end
    end
  end

  describe "agency_report" do
    let(:agency) { create(:agency) }
    let(:admins) { build_stubbed_list(:user, 2) }

    context 'when there are admins with no email preference' do
      it 'does not send the mail' do
        expect { Notifier.agency_report(agency) }
          .to change { ActionMailer::Base.deliveries.count }
          .by(0)
      end
    end

    context 'when there are admins with email preference' do
      let(:mail) { Notifier.agency_report(agency) }

      before do
        allow(agency).to receive(:admins_with_email_preference)
          .with('business_reports', 'business_performance_report')
          .and_return(admins)
      end

      it "renders the headers" do
        expect(mail.subject).to eq("#{agency.name} report - #{Date.current.strftime('%Y-%m-%d')}")
        expect(mail.to).to eq admins.pluck(:email)
        expect(mail.from).to eq ['support@clickx.io']
      end
    end
  end

  describe "marketing_performance_goal" do
    let(:mail) { Notifier.marketing_performance_goal(business, user) }

    it "renders the headers" do
      expect(mail.subject).to eq('Marketing Performance Goal')
      expect(mail.to).to eq(['vishnu@redpanthers.co'])
      expect(mail.from).to eq(["solomon@oneims.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Marketing Performance Goal line has been turned off for #{business} by #{user}")
    end
  end
end
