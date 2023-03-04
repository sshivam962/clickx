class ChangeSupportMembersImageToUploader < ActiveRecord::Migration[5.1]
  def up
    SupportMember.find_each do |member|
      next if member.image.blank?

      member.create_photo(remote_file_url: member.image)
    end
    remove_column :support_members, :image
  end

  def down
    add_column :support_members, :image, :string

    SupportMember.find_each do |member|
      member.update_attributes(image: member.photo&.file&.url)
    end
  end
end
