module DeviseDefs
  extend ActiveSupport::Concern

  included do
    # Include default devise modules. Others available are:
    # :registerable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable
  end
end