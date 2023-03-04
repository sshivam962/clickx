class ChangeDefaultValuesOfCompetitorFields < ActiveRecord::Migration[4.2]
  def up
    change_column_default :competitions, :backlinks, []
    change_column_default :competitions, :top_pages, []
    change_column_default :competitions, :keywords_organic, []
    change_column_default :competitions, :keywords_adwords, []

    [:backlinks, :top_pages, :keywords_organic, :keywords_adwords].each do |attribute|
      Competition.where("#{attribute}::text = '{}'").update_all(attribute => [])
    end
  end

  def down
    change_column_default :competitions, :backlinks, {}
    change_column_default :competitions, :top_pages, {}
    change_column_default :competitions, :keywords_organic, {}
    change_column_default :competitions, :keywords_adwords, {}
  end
end
