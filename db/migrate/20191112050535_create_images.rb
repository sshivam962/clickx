class CreateImages < ActiveRecord::Migration[5.1]
  def up
    create_table :images do |t|
      t.string :file
      t.references :imageable, polymorphic: true

      t.timestamps
    end

    CaseStudy.find_each do |case_study|
      next if case_study.descriptive_image.blank?

      image = case_study.images.create
      image.update_column('file', case_study.attributes['descriptive_image'])
    end
  end

  def down
    CaseStudy.find_each do |case_study|
      next if case_study.images.blank?

      case_study.update_column(
        'descriptive_image', case_study.images.first.attributes['file']
      )
    end
    drop_table :images
  end
end
