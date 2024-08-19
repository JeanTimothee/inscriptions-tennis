class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :edit, :update, :destroy, :submit]
  before_action :set_file_path
  before_action :authenticate_user!, only: [:page_perso]
  # after_action :delete_file, only: [:submit]

  require 'rubyXL/convenience_methods'
  require 'rubyXL'

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(registration_params)
  	if @registration.save
      redirect_to registration_path(@registration)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def submit
    workbook = RubyXL::Parser.parse(@file_path)
    worksheet = workbook[0]

    # destroy_rows(worksheet)

    @registration.clients.each do |client|
      unless client_already_exists?(worksheet, client)
        insert_client(worksheet, client)
      end
    end

    workbook.write(@file_path)

    pdf = RegistrationPdfGeneratorService.call(@registration)

    send_data(pdf, type: 'application/pdf', filename: "inscription_#{@registration.id}.pdf", disposition: 'inline')

  end

  def page_perso
    unless current_user.admin?
      redirect_to root_path
    end
  end

  def download

    send_file(@file_path, type: "application/xlsx", filename: "inscriptions_#{Date.today.strftime('%d/%m/%Y')}.xlsx", disposition: "inline")
  end

  def show
  end

  def edit
  end

  def update
     if @registration.update(registration_params)
      redirect_to registration_path(@registration)
    else
      render :edit
    end
  end

  def destroy
    Registration.find(params[:id])
    @registration.destroy
    redirect_to registrations_path
  end

  private

  def delete_file
    file_path = "#{Rails.root}/public/inscriptions/inscription_#{@registration.id}.pdf"
    File.delete(file_path) if File.exist?(file_path)
  end

  def client_already_exists?(worksheet, client)
    first_name_column_index = 2 # Assuming first_name is in column index 2 (adjust as per your sheet)
    last_name_column_index = 3  # Assuming last_name is in column index 3 (adjust as per your sheet)

    # Iterate through existing rows (excluding header row)
    worksheet.sheet_data.rows.drop(1).each do |row|
      if row[first_name_column_index].value == client.first_name &&
         row[last_name_column_index].value == client.last_name
        return true
      end
    end

    false
  end

  def set_registration
    @registration = Registration.find(params[:id])
  end

  def set_file_path
    @file_path = Rails.root.join('app', 'assets', 'xlsx', 'clients.xlsx')
  end

  def destroy_rows(worksheet)
    total_rows = worksheet.sheet_data.size
    # Loop through the rows in reverse order (except the first one) and delete them
    (total_rows - 1).downto(1) do |index|
      worksheet.delete_row(index)
    end
  end

  def insert_client(worksheet, client)
    data = [
      @registration.id.to_s,
      @registration.created_at.strftime("%d/%m/%Y"),
      client.first_name,
      client.last_name,
      client.mail,
      client.birthdate.strftime("%d/%m/%Y"),
      client.phone_1,
      client.phone_2,
      client.re_registration ? "Réinscription" : "Nouveau client",
      client.notes.nil? ? "" : client.notes
    ]
    last_row_index = worksheet.sheet_data.rows.size

    # Insert data into the new row
    data.each_with_index do |value, index|
      worksheet.add_cell(last_row_index, index, value)
    end
  end

  def registration_params
    params.require(:registration).permit(
      clients_attributes: [
        :id, :first_name, :last_name, :phone_1, :phone_2, :birthdate, :mail, :notes, :new_client, :re_registration, :_destroy
      ]
    )
  end
end
