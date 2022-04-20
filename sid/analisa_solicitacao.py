class Solicitacao:
    def __init__(self, guia, anexo_exame, anexo_laudo, situacao_financeira_cartao, situacao_cadastro_cartao, situacao_cadastro_referenciado) -> None:
        self._guia = guia
        self._anexo_exame = anexo_exame
        self._anexo_laudo = anexo_laudo
        self._situacao_financeira_cartao = situacao_financeira_cartao
        self._situacao_cadastro_cartao = situacao_cadastro_cartao
        self._situacao_cadastro_referenciado = situacao_cadastro_referenciado

    def julga_casos(self):
        liberacao_automatica = True
        analise_adm = True
        analise_medica = True
        if(self._guia == 'SADT' and (not self._anexo_exame)):
            liberacao_automatica = False
        if(self._guia == 'Internação' and (not self._anexo_laudo)):
            liberacao_automatica = False
        if(self._situacao_financeira_cartao == 'Atrasado'):
            liberacao_automatica = False
            analise_medica = False
        if(self._situacao_cadastro_cartao == 'Em auditoria' or self._situacao_cadastro_referenciado == 'Em auditoria'):
            liberacao_automatica = False
        if liberacao_automatica:
            resultado_solicitacao = "Liberado"
        else:
            resultado_solicitacao = "Negado: enviada para mesa"
        return liberacao_automatica, analise_adm, analise_medica, resultado_solicitacao


''' List all output parameters as comma-separated values in the "Output:" docString. Do not specify "None" if there is no output parameter. ''' # noqa
def execute (guia, anexo_exame, anexo_laudo, situacao_financeira_cartao, situacao_cadastro_cartao, situacao_cadastro_referenciado): # noqa
    'Output: liberacao_automatica, analise_adm, analise_medica'
    s = Solicitacao(guia, anexo_exame, anexo_laudo, situacao_financeira_cartao, situacao_cadastro_cartao, situacao_cadastro_referenciado)
    liberacao_automatica, analise_adm, analise_medica, resultado_solicitacao = s.julga_casos()
    return liberacao_automatica, analise_adm, analise_medica, resultado_solicitacao