class ClientCompaniesChannels < ApplicationCable::Channel
  def subscribed
    stream_from 'client_companies'
  end
end