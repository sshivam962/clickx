class MakeEmailFieldRequiredByDefault < ActiveRecord::Migration[5.1]
  def up
    EmbeddableContactFormField.where(name_slug: 'email').update_all(required: true)
  end

  def down
    EmbeddableContactFormField.where(name_slug: 'email').update_all(required: false)
  end
end
