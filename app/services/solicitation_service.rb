require 'httparty'

class SolicitationService
    def initialize(solicitation)
        @solicitation = solicitation
    end

    def update_solicitation_local
        @solicitation.update(automatic_release: true, adm_analysis: true, medic_analysis: true)
    end

    def update_solicitation_api
        self.call_sas_api
        @solicitation.update(automatic_release: false, adm_analysis: true, medic_analysis: true)
    end

    def call_sas_api
        # parâmetros de entrada SAS
        baseUrl = "https://server.demo.sas.com"
        username = "sasdemo"
        password = "Orion123"

        # Cria uma primeira chamada ao SID para gerar um token de acesso
        urlToken3 = baseUrl + "/SASLogon/oauth/token"
        headers3 = {
            "Content-Type": "application/x-www-form-urlencoded",
        }
        data3 = {
            "grant_type": "password",
            "username": username,
            "password": password
        }
        authToken = {username: "sas.cli", password: ""}

        token_response = HTTParty.post(urlToken3, :headers => headers3, :body => data3, :verify => false, :basic_auth => authToken)
        puts "RESPOSTA AQUI:"
        puts token_response
        puts token_response
        #@solicitation.procedure.cnpj_code
        #@solicitation
    end
end
