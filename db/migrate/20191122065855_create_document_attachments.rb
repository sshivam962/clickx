class CreateDocumentAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :document_attachments do |t|
      t.string :file
      t.integer :document_id
      t.timestamps
    end
  end
end
