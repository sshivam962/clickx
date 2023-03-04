# frozen_string_literal: true

module ClientHelper

  def tf_h_klass value
    value.present? ? '' : 'hidden'
  end

  def company_roles_collection
    [
      ['Company User', User::CompanyUser],
      ['Company Admin', User::CompanyAdmin]
    ]
  end
end
