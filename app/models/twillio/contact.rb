class Twillio::Contact < ApplicationRecord
  require 'roo'
  self.table_name_prefix = 'twillio_'

  validates :phone, presence: true, uniqueness: true

  has_many :sent_messages, class_name: 'Twillio::Message', foreign_key: :from, primary_key: :phone
  has_many :received_messages, class_name: 'Twillio::Message', foreign_key: :to, primary_key: :phone

  def display_name
    name.presence || phone
  end

  def user_name
    name
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    spreadsheet.each_row_streaming(offset: 1) do |row|
      contact_name = row[1].value.presence || ''
      contact = self.new(name: contact_name, phone: row[2].value.to_i)
      next if self.pluck(:phone).include?(contact.phone)

      contact.save
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.xls' then Roo::Excel.new(file.path)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
