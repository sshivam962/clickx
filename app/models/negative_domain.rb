class NegativeDomain < ApplicationRecord
  validates :name, uniqueness: true, presence: true

  before_validation do
    normalize_domain
  end

  private

  def normalize_domain
    name.strip!
    name.downcase!
    name.squish!

    self.name = URI.parse(domain_with_protocol(self.name)).host
  end

  def domain_with_protocol(domain)
    if domain[/^http/]
      domain
    else
      "http://#{domain}"
    end
  end
end
