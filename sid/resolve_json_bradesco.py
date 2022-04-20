import json

''' List all output parameters as comma-separated values in the "Output:" docString. Do not specify "None" if there is no output parameter. ''' # noqa
def execute (json_entrada): # noqa
    'Output: guia, anexo_exame, anexo_laudo, situacao_financeira_cartao, situacao_cadastro_cartao, situacao_cadastro_referenciado'
    j = json.loads(json_entrada)
    guia = j["guia"]
    anexo_exame = j["anexo_exame"]
    anexo_laudo = j["anexo_laudo"]
    situacao_financeira_cartao = j["situacao_financeira_cartao"]
    situacao_cadastro_cartao = j["situacao_cadastro_cartao"]
    situacao_cadastro_referenciado = j["situacao_cadastro_referenciado"]
    return guia, anexo_exame, anexo_laudo, situacao_financeira_cartao, situacao_cadastro_cartao, situacao_cadastro_referenciado