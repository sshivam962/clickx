class ChangeServiceToArrayInCaseStudies < ActiveRecord::Migration[5.1]
  def change
    add_column :case_studies, :services, :text, array: true, default: []
    CaseStudy.where.not(service: [nil, '']).find_each do |cs|
      cs.services = [cs.service]
      cs.save
    end
  end
end
