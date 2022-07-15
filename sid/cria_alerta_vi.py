# -*- coding: utf-8 -*-
import json
import requests # noqa
import random
import datetime

''' List all output parameters as comma-separated values in the "Output:" docString. Do not specify "None" if there is no output parameter. '''
def execute (guia,anexo_exame,anexo_laudo,situacao_financeira_cartao,situacao_cadastro_cartao,situacao_cadastro_referenciado,nome_beneficiario,cartao_beneficiario,codigo_procedimento,descricao_procedimento,codigo_referenciado,cnpj_referenciado,nome_referenciado,tabela_procedimento,liberacao_automatica,analise_adm,analise_medica,resultado_solicitacao,detalhe_resposta):
    'Output:resposta_vi, errorDescription'
    
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
    authToken =("sas.ec", "")
    errorDescription = ""
    try:
        tokenFinal = requests.post(urlToken3, data = data3,headers=headers3,verify=False, auth = authToken) 
    except requests.exceptions.RequestException as e:
        tokenFinal = e
        errorDescription = "falha no token"

    if errorDescription != "falha no token":
        tk = tokenFinal.json()["access_token"]
        print(tk)

        ##ENVIO ALERTA
        urlAlert = host + "/svi-alert/alertingEvents";

        headersAlert = {
            "Content-Type": "application/vnd.sas.fcs.tdc.alertingeventsdataflat+json; charset=utf-8",
            "Accept" : "application/vnd.sas.collection+json",
            "Authorization": "Bearer " + tk
            }
            
        ae_rand= "AE" + str(datetime.datetime.now().timestamp()).split('.')[0] + str(random.randint(17, 999999))
        sc_rand= "SC" + str(datetime.datetime.now().timestamp()).split('.')[0] + str(random.randint(17, 999999))
        cod_id = str(random.randint(17, 999999))

                            
        bodyAlert = {
                "alertingEvents": [{
                    "alertingEventId":""+ae_rand+"",
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
                    "alertingEventId":""+ae_rand+"",
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
        try:
            resposta = requests.post(urlAlert,data = json.dumps(bodyAlert),headers=headersAlert,verify=False)
            print("RESPOSTA: ", resposta)
        except requests.exceptions.RequestException as e:
            resposta = e
            errorDescription = "falha no post ao vi"
        resposta_vi = str(resposta)
    else:
        resposta_vi = str(tokenFinal)
    return resposta_vi, errorDescription


print(execute("teste",1.0,1.0,"teste","teste","teste","teste","teste","teste","teste","teste","teste","teste","teste",1.0,1.0,1.0,"teste","teste"))
