# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

staff = Staff.new(
    email: 'admin@admin.com',
    password: 'password',
    password_confirmation: 'password')
staff.skip_confirmation!
staff.save!

client = Client.new(
    email: 'client@client.com',
    fullname: 'Petrov Alexandr',
    phone: "8912345678",
    password: 'password',
    password_confirmation: 'password')
client.skip_confirmation!
client.save!

JuristicType.create(name: 'физ. лицо')
jur_type = JuristicType.create(name: 'юр. лицо')

Company.create(name: 'Central warehouse',
               juristic_type_id: jur_type.id,
               inn: 1234567890,
               ogrn: 1234567890)
