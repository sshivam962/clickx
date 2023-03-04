class RemoveImageFromDomainContacts < ActiveRecord::Migration[5.2]
  def change
    DomainContact.find_each(batch_size: 1000) do |domain_contact|
      next if domain_contact.image.blank? || domain_contact.email_sent_at.present?
      Cloudinary::Uploader.destroy(domain_contact.image.file.public_id, {invalidate: true})
      puts "contact id: #{domain_contact.id} : #{domain_contact.image.file.public_id}" 
    end
    remove_column :domain_contacts, :is_invalid_screenshot_url
    remove_column :domain_contacts, :image
  end
end
