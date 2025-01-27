class ApplicationsController < ApplicationController

  def show 
    @application = Application.find(params[:id])
    if params[:commit] == "Search"
      @search_pets = Pet.search(params[:pet_search])
    end
  end
 
  def new 

  end

  def create 
    @application = Application.create(application_params)
    if @application.valid?
      @application.save 
      redirect_to "/applications/#{@application.id}"
    else 
      flash.now[:notice] = "Error: Please fill out all fields!"
      render :new
    end
    
  end

  def update 
    @application = Application.find(params[:id])
    @application.update(application_params)
    @application.save 
    redirect_to "/applications/#{@application.id}"
  end

  def application_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :status, :description)
  end
end