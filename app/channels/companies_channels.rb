class CompaniesChannels < ApplicationCable::Channel
  def subscribed
    stream_from 'companies'
  end
end