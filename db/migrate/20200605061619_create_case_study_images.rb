class CreateCaseStudyImages < ActiveRecord::Migration[5.1]
  def up
    create_table :case_study_images do |t|
      t.string :file
      t.references :case_study
      t.integer :position

      t.timestamps
    end

    CaseStudy.find_each do |case_study|
      case_study.old_images.each do |image|
        image = case_study.images.create(file: open(image.file.url))
      end
    end
  end

  def down
    drop_table :case_study_images
  end
end
