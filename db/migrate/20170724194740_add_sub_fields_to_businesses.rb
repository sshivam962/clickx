class AddSubFieldsToBusinesses < ActiveRecord::Migration[4.2]
  def up
    add_column :businesses, :ga_sub, :string
    add_column :businesses, :sc_sub, :string

    Business.where.not(sub: nil).each do |biz|
      Token.where(sub: biz.sub).each do |t|
        case t.code_type
        when Token::AnalyticsAccessToken
          biz.update_attributes(ga_sub: biz.sub)
        when Token::SearchConsoleAccessToken
          biz.update_attributes(sc_sub: biz.sub)
        end
      end
    end

    remove_column :businesses, :sub, :string
  end

  def down
    remove_column :businesses, :ga_sub, :string
    remove_column :businesses, :sc_sub, :string

    add_column :businesses, :sub, :string
  end
end
