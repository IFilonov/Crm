class Company < ApplicationRecord
  belongs_to :juristic_type
  has_many :clients_companies, dependent: :destroy
  has_many :clients, through: :clients_companies
  has_many :devices

  after_save :broadcast

  private

  def broadcast
    ActionCable.server.broadcast('companies', { company: self })
  end
end
