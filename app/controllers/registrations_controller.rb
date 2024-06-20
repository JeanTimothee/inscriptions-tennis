class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :edit, :update, :destroy, :submit]
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
    file_path = Rails.root.join('app', 'assets', 'xlsx', 'clients.xlsx')
    workbook = RubyXL::Parser.parse(file_path)
    worksheet = workbook[0]

    destroy_rows(worksheet)
    insert_clients(workbook, worksheet, file_path)

    RegistrationPdfGeneratorService.call(@registration)

    send_file "#{Rails.root}/public/inscriptions/inscription_#{@registration.id}.pdf", type: 'application/pdf', disposition: 'inline' #filename: "inscription_#{@registration.id}.pdf"

    # redirect_to registration_path(@registration)
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

  def set_registration
    @registration = Registration.find(params[:id])
  end

  def destroy_rows(worksheet)
    total_rows = worksheet.sheet_data.size
    # Loop through the rows in reverse order (except the first one) and delete them
    (total_rows - 1).downto(1) do |index|
      worksheet.delete_row(index)
    end
  end

  def insert_clients(workbook, worksheet, file_path)
    @registration.clients.each do |client|
      data = [@registration.id.to_s, @registration.created_at.strftime("%d/%m/%Y"), client.first_name, client.last_name, client.mail, client.birthdate.strftime("%d/%m/%Y"), client.phone_1, client.phone_2, client.re_registration ? "Réinscritption" : "", client.notes.nil? ? "" : client.notes]
      last_row_index = worksheet.sheet_data.size
      worksheet.insert_row(last_row_index)

      # Insert data into the new row
      data.each_with_index do |value, index|
        worksheet.add_cell(last_row_index, index, value)
      end

      # Save the workbook
      workbook.write(file_path)
    end
  end

  def registration_params
    params.require(:registration).permit(
      clients_attributes: [
        :id, :first_name, :last_name, :phone_1, :phone_2, :birthdate, :mail, :notes, :new_client, :_destroy
      ]
    )
  end
end
