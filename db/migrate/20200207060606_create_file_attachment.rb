class CreateFileAttachment < ActiveRecord::Migration[5.1]
  def change
    create_table :file_attachments do |t|
      t.string :file
      t.references :file_attachable, polymorphic: true,
                   index: { name: :file_attachable_index }

      t.timestamps
    end
  end
end
