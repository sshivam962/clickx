class AddStyleToSocialMagnetTemplates < ActiveRecord::Migration[4.2]
  def change
    add_column :social_magnet_templates, :style, :jsonb, default: {
      button: {
        'background-color': '#4C4E60',
        'color': '#FFFFFF',
        'padding-top': '10px',
        'padding-bottom': '10px',
        'padding-left': '10px',
        'padding-right': '10px',
        'font-size': '18px',
        'width': '315px'
      }
    }
  end
end
