Money::Bank::FixerCurrency.ttl_in_seconds = 86400
Money.default_bank = Money::Bank::FixerCurrency.new(ENV['FIXER_API_KEY'])
