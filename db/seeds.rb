# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

JuristicType.create(name: 'физическое лицо')
jur_type = JuristicType.create(name: 'юридическое лицо')
Company.create(name: 'Центральный склад', juristic_type_id: jur_type.id, inn: 1111111111, ogrn: 1111111111 )