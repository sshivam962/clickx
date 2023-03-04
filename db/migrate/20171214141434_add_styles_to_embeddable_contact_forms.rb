class AddStylesToEmbeddableContactForms < ActiveRecord::Migration[5.1]
  def change
    add_column :embeddable_contact_forms, :style, :jsonb, default: {
      'form': {
        'background-color': '#ffffff',
        'color': '#777777',
        'font-size': '18px',
      },
      'button': {
        'background-color': '#007aff',
        'color': '#ffffff',
        'font-size': '18px'
      }
    }
  end
end
