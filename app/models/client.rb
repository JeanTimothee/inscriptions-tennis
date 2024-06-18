class Client < ApplicationRecord
  belongs_to :registration

  validates :first_name, :last_name, :phone_1, :mail, :birthdate, presence: true
end
