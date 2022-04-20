# -*- coding: utf-8 -*-
import json
import requests # noqa
import random
import datetime

''' List all output parameters as comma-separated values in the "Output:" docString. Do not specify "None" if there is no output parameter. '''
def execute (guia, anexo_exame, anexo_laudo, situacao_financeira_cartao, situacao_cadastro_cartao, situacao_cadastro_referenciado, nome_beneficiario, cartao_beneficiario, codigo_procedimento, descricao_procedimento, codigo_referenciado, cnpj_referenciado, nome_referenciado, tabela_procedimento, liberacao_automatica, analise_adm, analise_medica, resultado_solicitacao): # noqa
    'Output: resposta_vi'
    host = 'http://13.90.73.61'
    username = "t5user01"
    password = "Orion1234"

    urlToken3 = host + "/SASLogon/oauth/token"
    headers3 = {
        "Content-Type": "application/x-www-form-urlencoded",
    }

    data3 = {
        "grant_type": "password",
        "username": username,
        "password": password
    }
    authToken =("sas.cli", "")

    tokenFinal = requests.post(urlToken3, data = data3,headers=headers3,verify=False, auth = authToken)    

    tk = tokenFinal.json()["access_token"]

    ##ENVIO ALERTA
    urlAlert = host + "/svi-alert/alertingEvents";

    headersAlert = {
        "Content-Type": "application/vnd.sas.fcs.tdc.alertingeventsdataflat+json; charset=utf-8",
        "Accept" : "application/vnd.sas.collection+json",
        "Authorization": "Bearer " + tk
        }
        
    ae_rand= "AE" + str(datetime.datetime.now().timestamp()).split('.')[0] + str(random.randint(17, 999999))
    sc_rand= "SC" + str(datetime.datetime.now().timestamp()).split('.')[0] + str(random.randint(17, 999999))

                        
    bodyAlert = {
            "alertingEvents": [{
                "alertingEventId":""+ae_rand+"",
                "actionableEntityId": ""+ae_rand+"",
                "actionableEntityType": "autorizacao_senha",
                "alertOriginCd": "SID",
                "alertTypeCd": "AUTORIZACAO",
                "domainId": "mesa_prev_sky",
                "score": 1000,
                "recQueueId": "prev_pf_operation_queue"
            }],
            "scenarioFiredEvents": [{
                "alertingEventId": ""+ae_rand+"",
                "scenarioFiredEventId": ""+sc_rand+"",
                "scenarioId": "nomeRegra", #validar
                "scenarioName": "resposta", #validar
                "scenarioDeion": "resposta", #validar
                "scenarioOriginCd": "SID",
                "displayFlg": "true",
                "displayTypeCd": "text",
                "score": 1000
            }],
            "enrichment": [{
                "guia": guia,
                "anexo_exame": anexo_exame,
                "anexo_laudo": anexo_laudo,
                "situacao_financeira_cartao": situacao_financeira_cartao,
                "situacao_cadastro_cartao": situacao_cadastro_cartao,
                "situacao_cadastro_referenciado": situacao_cadastro_referenciado,
                "nome_beneficiario": nome_beneficiario,
                "cartao_beneficiario": cartao_beneficiario,
                "codigo_procedimento": codigo_procedimento,
                "descricao_procedimento": descricao_procedimento,
                "codigo_referenciado": codigo_referenciado,
                "cnpj_referenciado": cnpj_referenciado,
                "nome_referenciado": nome_referenciado,
                "tabela_procedimento": tabela_procedimento,
                "liberacao_automatica": liberacao_automatica,
                "analise_adm": analise_adm,
                "analise_medica": analise_medica,
                "resultado_solicitacao": resultado_solicitacao
            }]
    }
    resposta_vi = requests.post(urlAlert,data = json.dumps(bodyAlert),headers=headersAlert,verify=False)

    return resposta_vi
