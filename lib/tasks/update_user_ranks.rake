# frozen_string_literal: true

task update_user_ranks: :environment do
  Merit::RankRules.new.check_rank_rules
end
