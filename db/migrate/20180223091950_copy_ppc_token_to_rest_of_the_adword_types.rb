class CopyPpcTokenToRestOfTheAdwordTypes < ActiveRecord::Migration[5.1]
  def up
    Business.joins(:tokens).where(tokens: {code_type: 'google_adwords'}).find_each do |business|
      ['google_adwords_display', 'google_adwords_retargeting', 'google_adwords_video'].each do |code_type|
        token = business.tokens.find_by(code_type: 'google_adwords').dup
        token.code_type = code_type
        token.save
      end
    end
  end
end
