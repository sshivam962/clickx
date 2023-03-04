class AddQuestionnaireHeaderColorToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :questionnaire_header_color, :string, default: '#4C4E60'
  end
end
