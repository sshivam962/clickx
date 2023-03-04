class ChangeAuditRequestDataInLeads < ActiveRecord::Migration[5.1]
  def up
    ::Lead.find_each do |lead|
      next if lead.audit_request.blank?

      if lead.audit_request.include?('No Access')
        lead.update(audit_request: lead.audit_request.gsub('No Access', 'No'))
      else
        lead.update(audit_request: lead.audit_request.gsub('Access', 'Yes'))
      end
    end
  end

  def down
    ::Lead.find_each do |lead|
      next if lead.audit_request.blank?

      if lead.audit_request.include?('No')
        lead.update(audit_request: lead.audit_request.gsub('No', 'No Access'))
      else
        lead.update(audit_request: lead.audit_request.gsub('Yes', 'Access'))
      end
    end
  end
end
