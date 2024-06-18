class RegistrationsController < ApplicationController
  def new
    @registration = Registration.new
    # @client = Client.new
  end

  def create
    @registration = Registration.new(registration_params)
  	if @registration.save
      redirect_to edit_registration_path(@registration)
    else
      render :new, status: :unprocessable_entity
    end
  end

    def edit
    @registration = Registration.find(params[:id])
  end

  def update
    @registration = Registration.find(params[:id])

     if @registration.update(registration_params)
      redirect_to edit_registration_path(@registration)
    else
      render :edit
    end
  end

  def destroy
    Registration.find(params[:id]).destroy
    redirect_to registrations_path
  end

  def registration_params
    params.require(:registration).permit(
      clients_attributes: [
        :id, :first_name, :last_name, :phone_1, :phone_2, :birthdate, :mail, :notes, :new_client, :_destroy
      ]
    )
  end
end
