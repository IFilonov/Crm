class Client < ApplicationRecord

  include DeviseDefs
  validates :fullname, :email, :phone, presence: true
end
