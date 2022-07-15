require 'httparty'
require 'json'
require 'time'

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
        unless @solicitation.automatic_release
            self.call_vi
        end
    end

    def call_sas_api
        # parâmetros de entrada SAS
        baseUrl = "http://server.demo.sas.com"
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
            urlSID = baseUrl + "/microanalyticScore/modules/analisa_solicitacao_bradesco/steps/execute"
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
                "cartao_beneficiario": @solicitation.beneficiary.card.to_s,
                "codigo_procedimento": @solicitation.procedure.code.to_s,
                "descricao_procedimento": @solicitation.procedure.description,
                "codigo_referenciado": @solicitation.referenced.code.to_s,
                "cnpj_referenciado": @solicitation.referenced.cnpj_code.to_s,
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

    def simulate_json
        ae_rand= "AE" + Time.now.utc.to_formatted_s(:number) + rand(17..999999).to_s 
        sc_rand= "SC" + Time.now.utc.to_formatted_s(:number) + rand(17..999999).to_s
        bodyAlert = {
            "alertingEvents": [JSON.generate({
                "alertingEventId":""+ae_rand+"",
                "actionableEntityId": ""+ae_rand+"",
                "actionableEntityType": "autorizacao_senha",
                "alertOriginCd": "SID",
                "alertTypeCd": "AUTORIZACAO",
                "domainId": "mesa_prev_sky",
                "score": 1000,
                "recQueueId": "prev_pf_operation_queue"
            })],
            "scenarioFiredEvents": [JSON.generate({
                "alertingEventId": ""+ae_rand+"",
                "scenarioFiredEventId": ""+sc_rand+"",
                "scenarioId": "nomeRegra", #validar
                "scenarioName": "resposta", #validar
                "scenarioDeion": "resposta", #validar
                "scenarioOriginCd": "SID",
                "displayFlg": "true",
                "displayTypeCd": "text",
                "score": 1000
            })],
            "enrichment": [JSON.generate({
                "guia": @solicitation.procedure.guide,
                "anexo_exame": self.converter_boolean_int(@solicitation.attachment_exam_guide),
                "anexo_laudo": self.converter_boolean_int(@solicitation.attachment_medical_report),
                "situacao_financeira_cartao": @solicitation.beneficiary.finantial_status,
                "situacao_cadastro_cartao": @solicitation.beneficiary.register_status,
                "situacao_cadastro_referenciado": @solicitation.referenced.register_status,
                "nome_beneficiario": @solicitation.beneficiary.name,
                "cartao_beneficiario": @solicitation.beneficiary.card.to_s,
                "codigo_procedimento": @solicitation.procedure.code.to_s,
                "descricao_procedimento": @solicitation.procedure.description,
                "codigo_referenciado": @solicitation.referenced.code.to_s,
                "cnpj_referenciado": @solicitation.referenced.cnpj_code.to_s,
                "nome_referenciado": @solicitation.referenced.name,
                "tabela_procedimento": @solicitation.procedure.table_type,
                "liberacao_automatica": @solicitation.automatic_release,
                "analise_adm": @solicitation.adm_analysis,
                "analise_medica": @solicitation.medic_analysis,
                "resultado_solicitacao": @solicitation.result
            })]
        }
        puts bodyAlert
    end

    def call_vi
        host = 'https://tenant5.demoserver.internal.cloudapp.net'
        username = "t5user01"
        password = "Orion123"

        urlToken3 = host + "/SASLogon/oauth/token"
        headers3 = {
            "Content-Type": "application/x-www-form-urlencoded",
        }

        data3 = {
            "grant_type": "password",
            "username": username,
            "password": password
        }
        authToken = {username: "sas.ec", password: ""}
        errorDescription = ""
        puts "TENTATIVA REQUISICAO"

        begin
            token_response = HTTParty.post(urlToken3, :headers => headers3, :body => data3, :verify => false, :basic_auth => authToken)
        rescue HTTParty.exception => e
            puts e
        end

        puts "RESPOSTA TOKEN VIII -------------"
        puts token_response

        # Faz a requisição ao SAS com o Token recebido
        if token_response.include?("access_token")
            tk = token_response["access_token"]

            ##ENVIO ALERTA
            urlAlert = host + "/svi-alert/alertingEvents";

            headersAlert = {
                "Content-Type": "application/vnd.sas.fcs.tdc.alertingeventsdataflat+json; charset=utf-8",
                "Accept": "application/vnd.sas.collection+json",
                "Authorization": "Bearer " + tk
            }

            ae_rand= "AE" + Time.now.utc.to_formatted_s(:number) + rand(17..999999).to_s 
            sc_rand= "SC" + Time.now.utc.to_formatted_s(:number) + rand(17..999999).to_s
            cod_id = rand(17..999999).to_s
            detalhe_resposta = "Enviado para mesa de investigação a partir da aplicação SID"
            bodyAlert = {
                "alertingEvents": [{
                    "alertingEventId": ""+ae_rand+"",
                    "actionableEntityId": ""+ae_rand+"",
                    "actionableEntityType": "AutorizacaoSenha",
                    "alertOriginCd": "SID",
                    "alertTypeCd": "AUTORIZACAO",
                    "domainId": "svidomain",
                    "score": 900,
                    "recQueueId": "AutSenha"
                }],
                "scenarioFiredEvents": [{
                    "alertingEventId": ""+ae_rand+"",
                    "scenarioFiredEventId": ""+sc_rand+"",
                    "scenarioId": cod_id,
                    "scenarioDescription": detalhe_resposta,
                    "messageTemplateTxt": detalhe_resposta,
                    "scenarioOriginCd": "SID",
                    "displayFlg": "true",
                    "displayTypeCd": "text",
                    "score": 900
                }],
                "enrichment": [{
                    "alertingEventId": ""+ae_rand+"",
                    "guia": @solicitation.procedure.guide,
                    "anexo_exame": self.converter_boolean_int(@solicitation.attachment_exam_guide),
                    "anexo_laudo": self.converter_boolean_int(@solicitation.attachment_medical_report),
                    "situacao_financeira_cartao": @solicitation.beneficiary.finantial_status,
                    "situacao_cadastro_cartao": @solicitation.beneficiary.register_status,
                    "situacao_cadastro_referenciado": @solicitation.referenced.register_status,
                    "nome_beneficiario": @solicitation.beneficiary.name,
                    "cartao_beneficiario": @solicitation.beneficiary.card.to_s,
                    "codigo_procedimento": @solicitation.procedure.code.to_s,
                    "descricao_procedimento": @solicitation.procedure.description,
                    "codigo_referenciado": @solicitation.referenced.code.to_s,
                    "cnpj_referenciado": @solicitation.referenced.cnpj_code.to_s,
                    "nome_referenciado": @solicitation.referenced.name,
                    "tabela_procedimento": @solicitation.procedure.table_type,
                    "liberacao_automatica": self.converter_boolean_int(@solicitation.automatic_release),
                    "analise_adm": self.converter_boolean_int(@solicitation.adm_analysis),
                    "analise_medica": self.converter_boolean_int(@solicitation.medic_analysis),
                    "resultado_solicitacao": @solicitation.result
                }]
            }
            puts "BODY ======"
            puts bodyAlert
            resposta_vi = HTTParty.post(urlAlert, :headers => headersAlert, :body => JSON.generate(bodyAlert), :verify => false)
            puts "RESPOSTA VI ===="
            puts resposta_vi
        end
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
