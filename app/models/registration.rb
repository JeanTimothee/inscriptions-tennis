class Registration < ApplicationRecord
  include Abyme::Model
  has_many :clients, inverse_of: :registration, dependent: :destroy
  abymize :clients
end
