class Solicitation < ApplicationRecord
  belongs_to :beneficiary
  belongs_to :procedure
  belongs_to :referenced
end
