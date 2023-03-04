class AddInTheirWordsToCaseStudies < ActiveRecord::Migration[5.2]
  def change
    add_column :case_studies, :in_their_words, :text
  end
end
