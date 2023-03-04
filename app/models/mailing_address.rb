class MailingAddress < Address
  belongs_to :mailing_addressable, polymorphic: true,
    foreign_type: :addressable_type, foreign_key: :addressable_id
end
