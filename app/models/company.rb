class Company < ApplicationRecord
  belongs_to :juristic_type
  has_many :clients_companies, dependent: :destroy
  has_many :clients, through: :clients_companies
end
