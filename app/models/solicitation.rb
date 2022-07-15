class Solicitation < ApplicationRecord
  belongs_to :beneficiary
  belongs_to :procedure
  belongs_to :referenced

  after_create :call_solicitation_service

  def call_solicitation_service
    local = false
    if local
      SolicitationService.new(self).update_solicitation_local
    else
      SolicitationService.new(self).update_solicitation_api
    end
  end
end
