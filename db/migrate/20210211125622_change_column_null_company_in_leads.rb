class ChangeColumnNullCompanyInLeads < ActiveRecord::Migration[5.1]
  def change
    change_column_null :leads, :company, true
  end
end
