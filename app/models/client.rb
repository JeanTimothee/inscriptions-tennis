class Client < ApplicationRecord
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  TELEPHONE_REGEX = /\A\+?[0-9\s\-]{7,15}\z/

  belongs_to :registration

  validates :first_name, :last_name, :phone_1, :mail, :birthdate, presence: true
  validate :email_format
  validate :telephone_format

  private

  def email_format
    if mail.present? && !mail.match?(EMAIL_REGEX)
      errors.add(:mail, :invalid, message: I18n.t('activerecord.errors.models.client.attributes.email.invalid'))
    end
  end

  def telephone_format
    if phone_1.present? && !phone_1.match?(TELEPHONE_REGEX)
      errors.add(:phone_1, :invalid, message: I18n.t('activerecord.errors.models.client.attributes.phone.invalid'))
    end
  end
end
