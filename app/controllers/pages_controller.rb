class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:page_perso]

  def page_perso
    unless current_user.admin?
      redirect_to root_path
    end
  end


  def download
    @file_path = Rails.root.join('app', 'assets', 'xlsx', 'clients.xlsx')
    send_file(@file_path, type: "application/xlsx", filename: "inscriptions_#{Date.today.strftime('%d/%m/%Y')}.xlsx", disposition: "inline")
  end

end
