class AddIcebreakerSentenceToAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :icebreaker_sentence, :string, default: 'write an icebreaker sentence before pitching my services to them.'
  end
end
