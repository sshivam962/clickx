class CreateCaseStudyIndustries < ActiveRecord::Migration[5.1]
  def change
    create_table :case_study_industries do |t|
      t.references :case_study, foreign_key: true
      t.references :industry, foreign_key: true

      t.timestamps
    end

    CaseStudy.find_each do |cs|
      CaseStudyIndustry.create(case_study: cs, industry_id: cs.industry_id)
    end
  end
end
