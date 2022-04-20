require 'httparty'
require 'json'

class SolicitationService
    def initialize(solicitation)
        @solicitation = solicitation
    end

    def update_solicitation_local
        @solicitation.update(automatic_release: true, adm_analysis: true, medic_analysis: true, result: "Aprovado")
    end

    def update_solicitation_api
        analise_medica, analise_adm, liberacao_automatica, resultado_solicitacao = self.call_sas_api
        @solicitation.update(automatic_release: liberacao_automatica, adm_analysis: analise_adm, medic_analysis: analise_medica, result: resultado_solicitacao)
    end

    def call_sas_api
        # parâmetros de entrada SAS
        baseUrl = "http://10.96.14.236/"
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
        puts "RESPOSTA TOKEN -------------"
        puts token_response

        # Faz a requisição ao SAS com o Token recebido
        if token_response.include?("access_token")
            tk = token_response["access_token"]
            urlSID = baseUrl + "/microanalyticScore/modules/bradescosolicitation/steps/execute"
            headersSID = {
                "Content-Type": "application/json;charset=utf-8",
                "Accept": "application/json",
                "Authorization": "Bearer " + tk
            }
            json_entrada = {
                "guia": @solicitation.procedure.guide,
                "anexo_exame": self.converter_boolean_int(@solicitation.attachment_exam_guide),
                "anexo_laudo": self.converter_boolean_int(@solicitation.attachment_medical_report),
                "situacao_financeira_cartao": @solicitation.beneficiary.finantial_status,
                "situacao_cadastro_cartao": @solicitation.beneficiary.register_status,
                "situacao_cadastro_referenciado": @solicitation.referenced.register_status,
                "nome_beneficiario": @solicitation.beneficiary.name,
                "cartao_beneficiario": @solicitation.beneficiary.card,
                "codigo_procedimento": @solicitation.procedure.code,
                "descricao_procedimento": @solicitation.procedure.description,
                "codigo_referenciado": @solicitation.referenced.code,
                "cnpj_referenciado": @solicitation.referenced.cnpj_code,
                "nome_referenciado": @solicitation.referenced.name,
                "tabela_procedimento": @solicitation.procedure.table_type
            }
            bodySID = {
                "inputs":
                    [
                        {
                            "name": "json_entrada_",
                            "value": JSON.generate(json_entrada)
                        }
                    ]
            }

            resposta = HTTParty.post(urlSID, :body => JSON.generate(bodySID), :headers => headersSID, :verify => false)
            puts "RESPOSTA FLUXO ---------------"
            puts resposta
            puts JSON.parse(resposta)["outputs"]

            # Trabalha nas respostas recebidas
            analise_medica = true
            analise_adm = true
            liberacao_automatica = true
            resultado_solicitacao = "Pendente"
            for output in JSON.parse(resposta)["outputs"] do
                if output["name"] == "analise_medica"
                    analise_medica = self.converter_int_boolean(output["value"])
                end
                if output["name"] == "analise_adm"
                    analise_adm = self.converter_int_boolean(output["value"])
                end
                if output["name"] == "liberacao_automatica"
                    liberacao_automatica = self.converter_int_boolean(output["value"])
                end
                if output["name"] == "resultado_solicitacao"
                    resultado_solicitacao = output["value"]
                end
            end
        else
            puts "DEU RUIM -----------------"
            # Trabalha nas respostas recebidas
            analise_medica = false
            analise_adm = false
            liberacao_automatica = false
            resultado_solicitacao = "Cancelado"
        end

        return analise_medica, analise_adm, liberacao_automatica, resultado_solicitacao
    end

    def converter_boolean_int(b)
        number = 0
        if b
            number = 1
        end
        return number
    end

    def converter_int_boolean(i)
        bool = false
        if i == 1.0
            bool = true
        end
        return bool
    end
end
