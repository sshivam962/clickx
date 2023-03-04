class CreateAdminFaqs < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_faqs do |t|
      t.string :question
      t.string :answer

      t.timestamps
    end
  end
end
