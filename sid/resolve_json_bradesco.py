import json

def retorna_booleano(number: int):
    response = False
    if number == 1:
        response = True
    return response

''' List all output parameters as comma-separated values in the "Output:" docString. Do not specify "None" if there is no output parameter. ''' # noqa
def execute (json_entrada): # noqa
    'Output: guia, anexo_exame, anexo_laudo, situacao_financeira_cartao, situacao_cadastro_cartao, situacao_cadastro_referenciado, nome_beneficiario, cartao_beneficiario, codigo_procedimento, descricao_procedimento, codigo_referenciado, cnpj_referenciado, nome_referenciado, tabela_procedimento'
    j = json.loads(json_entrada)
    guia = j["guia"]
    situacao_financeira_cartao = j["situacao_financeira_cartao"]
    situacao_cadastro_cartao = j["situacao_cadastro_cartao"]
    situacao_cadastro_referenciado = j["situacao_cadastro_referenciado"]
    nome_beneficiario = j["nome_beneficiario"]
    cartao_beneficiario = j["cartao_beneficiario"]
    codigo_procedimento = j["codigo_procedimento"]
    descricao_procedimento = j["descricao_procedimento"]
    codigo_referenciado = j["codigo_referenciado"]
    cnpj_referenciado = j["cnpj_referenciado"]
    nome_referenciado = j["nome_referenciado"]
    tabela_procedimento = j["tabela_procedimento"]
    anexo_exame = retorna_booleano(j["anexo_exame"])
    anexo_laudo = retorna_booleano(j["anexo_laudo"])

    return guia, anexo_exame, anexo_laudo, situacao_financeira_cartao, situacao_cadastro_cartao, situacao_cadastro_referenciado, nome_beneficiario, cartao_beneficiario, codigo_procedimento, descricao_procedimento, codigo_referenciado, cnpj_referenciado, nome_referenciado, tabela_procedimento
