# frozen_string_literal: true

# Be sure to restart your server when you modify this file.
#
# 5 stars is a common ranking use case. They are not given at specified
# actions like badges, you should define a cron job to test if ranks are to be
# granted.
#
# +set_rank+ accepts:
# * :+level+ ranking level (greater is better)
# * :+to+ model or scope to check if new rankings apply
# * :+level_name+ attribute name (default is empty and results in 'level'
#   attribute, if set it's appended like 'level_#{level_name}')

module Merit
  class RankRules
    include Merit::RankRulesMethods

    def initialize
      set_rank level: 1, to: User.normal do |user|
        user.visits.empty? || (user.last_seen > 30.days.from_now)
      end

      set_rank level: 2, to: User.normal do |user|
        (!user.visits.empty? and user.visits.size < 30) and (user.last_seen < 30.days.from_now)
      end

      set_rank level: 3, to: User.normal do |user|
        (user.visits.size > 30) and (user.last_seen < 30.days.from_now)
      end
    end
  end
end
