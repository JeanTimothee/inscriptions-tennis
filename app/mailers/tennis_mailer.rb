class TennisMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tennis_mailer.update.subject
  #
  def update
    @file_path = params[:file_path]
    attachments["inscriptions-#{Date.today}.xlsx"] = File.read(@file_path)

    mail(to: "tccourcelles@gmail.com", subject: "Nouvelles inscriptions")
  end
end
