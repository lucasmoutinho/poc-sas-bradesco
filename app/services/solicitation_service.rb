class SolicitationService
    def initialize(solicitation)
        @solicitation = solicitation
    end

    def update_solicitation
        @solicitation.update(automatic_release: true, adm_analysis: true, medic_analysis: true)
    end

    #def call_sas_api
    #  @solicitation.procedure.cnpj_code
    #  @solicitation
    # end
end