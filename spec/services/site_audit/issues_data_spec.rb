# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SiteAudit::IssuesData do
  let(:business) { create(:business) }
  let(:company_admin) { create(:company_admin) }

  it 'works when site-audit service is disable' do
    data = described_class.call(business, {})
    expect(data.payload[:error]).to be_eql('Could not find site_audit_service')
  end

  context 'when site-audit service is enable' do
    before do
      allow(business).to receive(:site_audit_service).and_return(true)
    end

    context 'when leo project is not created' do
      it 'create leo project with valid domain' do
        valid_data = { 'id' => 'f3c29c67-366c-4294-bd90-05767f674953' }
        allow_any_instance_of(described_class).to receive(:create_leo_project).and_return(valid_data)
        data = described_class.call(business, {})
        expect(data.payload[:message]).to be_eql('Crawling in progress. Please try again later')
      end
      it 'create leo project with invalid domain' do
        invalid_data = { 'errors' => ['is invalid'] }
        allow_any_instance_of(described_class).to receive(:create_leo_project).and_return(invalid_data)
        data = described_class.call(business, {})
        expect(data.payload[:error]).not_to be_blank
      end
    end

    context "when leo_api_datum doesn't exist" do
      before do
        business.leo_api_datum.delete
        business.reload
      end

      it 'create leo_api_datum' do
        valid_data = { 'id' => 'f3c29c67-366c-4294-bd90-05767f674953' }
        allow_any_instance_of(described_class).to receive(:create_leo_project).and_return(valid_data)
        data = described_class.call(business, {})
        expect(data.payload[:message]).to be_eql('Crawling in progress. Please try again later')
      end
    end

    context 'when leo project is created' do
      let(:leo_api_datum) { create(:leo_api_datum) }
      let(:site_audit_issue) { create(:site_audit_issue, leo_api_datum: leo_api_datum) }

      before do
        allow_any_instance_of(described_class).to receive(:leo_api_datum).and_return(leo_api_datum)
      end
      it 'return message if site audit issue is not present' do
        data = described_class.call(business, {})
        expect(data.payload[:message]).to be_eql('Crawling in progress. Please try again later')
      end
      context 'When issue data is present' do
        before do
          site_audit_issues = create(:site_audit_issue, url: 'https://www.clickx.io/author/solomon/',
                                                        leo_api_datum_id: leo_api_datum.id)
        end
        context 'when params contains search' do
          it 'return value for valid search' do
            params = { search: 'clickx' }
            data = described_class.call(business, params)
            expect(data.payload[:data]).not_to be_blank
          end

          it 'return blank for invalid search' do
            params = { search: 'seo' }
            data = described_class.call(business, params)
            expect(data.payload[:data]).to be_blank
          end
        end

        context 'when params not contains search' do
          it 'params[:limit] == 1' do
            params = { limit: '1' }
            data = described_class.call(business, params)
            expect(data.payload[:data]).not_to be_blank
          end
          it 'params[:limit] and params[:offset]' do
            params = { limit: 10, offset: 0 }
            data = described_class.call(business, params)
            expect(data.payload[:data]).not_to be_blank
          end
          it 'params[:limit] and params[:offset]' do
            data = described_class.call(business, {})
            expect(data.payload[:data]).not_to be_blank
          end
        end
      end
    end
  end
end
