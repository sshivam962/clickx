class AddTierToCaseStudies < ActiveRecord::Migration[5.1]
  def up
    add_column :case_studies, :tier, :integer
    CaseStudy.update_all(tier: 'free')
  end

  def down
    remove_column :case_studies, :tier
  end
end
