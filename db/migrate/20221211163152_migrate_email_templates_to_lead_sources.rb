class MigrateEmailTemplatesToLeadSources < ActiveRecord::Migration[5.2]
  def up
    ActiveRecord::Base.transaction do
      LeadSource.find_each do |lead_source|
        next if lead_source.subject.blank? && lead_source.email_template.blank? && lead_source.word_press.blank?

        agency = lead_source.agency
        email_template = agency.email_templates.create(
          name: lead_source.name + ' Email Template',
          subject: lead_source.subject,
          content: lead_source.email_template,
          wordpress_site_custom_content: lead_source.word_press
        )
        lead_source.email_templates << email_template
      end
    end
  end

  def down
    EmailTemplate.all.map(&:destroy)
  end
end
