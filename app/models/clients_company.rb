class ClientsCompany < ApplicationRecord
  belongs_to :company
  belongs_to :client

  after_save :broadcast

  def broadcast
    ActionCable.server.broadcast('client_companies', { client_id: self.client_id, company: self.company })
    puts "*******************"
    puts self.company
  end
end
