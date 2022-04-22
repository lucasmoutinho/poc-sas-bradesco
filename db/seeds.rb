# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Beneficiary.create(card: 814832000019008, name: 'Isauro', finantial_status: 'Em dia', register_status: 'Em dia')
Beneficiary.create(card: 960017444192005, name: 'Cliente Premium', finantial_status: 'Em dia', register_status: 'Em dia')
Beneficiary.create(card: 960017148313006, name: 'Akvox', finantial_status: 'Atrasado', register_status: 'Em dia')
Beneficiary.create(card: 960017568206003, name: 'Felipe', finantial_status: 'Em dia', register_status: 'Em auditoria')


Procedure.create(table_type: 'THSM', code: 20010, description: 'Visita Hospitalar', guide: 'Internação')
Procedure.create(table_type: 'TUSS', code: 10102019, description: 'Visita Hospitalar', guide: 'Internação')
Procedure.create(table_type: 'TUSS', code: 51010024, description: 'Cintilografia Miocárdio Necrose', guide: 'SADT')
Procedure.create(table_type: 'TUSS', code: 51010032, description: 'Cintilografia Miocárdio perfil repouso e estresse', guide: 'SADT')
Procedure.create(table_type: 'TUSS', code: 22010149, description: 'Polissonografia', guide: 'SADT')
Procedure.create(table_type: 'TUSS', code: 50715016, description: 'Artrodese da coluna c/ instrução por segmento', guide: 'Internação')


Referenced.create(code: 16710, cnpj_code: 60922168000348, name: 'Casa de Saúde São José', register_status: 'Em dia')
Referenced.create(code: 16675, cnpj_code: 42297507000107, name: 'Balbino', register_status: 'Em dia')
Referenced.create(code: 16895, cnpj_code: 26227959000158, name: 'Instituto Estadual de Diagnóstico', register_status: 'Em auditoria')
