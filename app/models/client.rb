class Client < ApplicationRecord
  has_many :clients_companies, dependent: :destroy
  has_many :companies, through: :clients_companies

  include DeviseDefs
  validates :fullname, :email, :phone, presence: true
end
