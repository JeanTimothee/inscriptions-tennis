# Preview all emails at http://localhost:3000/rails/mailers/tennis_mailer
class TennisMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/tennis_mailer/update
  def update
    TennisMailer.update
  end

end
