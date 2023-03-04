class ProjectProposal < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true

  def clickx_fee
    amount * 20/100
  end

  def total_amount
    amount + clickx_fee
  end
end
