class LocationsController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource
 
    before_action :require_login
    before_action :authenticate_user!
    before_action :set_location, only: [:show, :edit, :update, :destroy]

    layout 'bibliography'

    def index
        @locations = Location.all
    end

    def show
    end

    def new
        @location = Location.new
    end

    def edit
    end

    def create
        @location = Location.new(location_params)

        if @location.save
            respond_to do |format|
                format.html { redirect_to @location, notice: 'Location was successfully created.' }
                format.json { render :show, status: :created, location: @location }
            end
        else
            respond_to do |format|
                format.html { render :new }
                format.json { render json: @location.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        if @location.update!(location_params)
            respond_to do |format|
                format.html { redirect_to @location, notice: 'Location was successfully updated.' }
                format.json { render :show, status: :ok, location: @location }
            end
        else
            respond_to do |format|
                format.html { render :edit }
                format.json { render json: @location.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @location.destroy
        respond_to do |format|
            format.html { redirect_to locations_path, notice: 'Location was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_location
            begin
                @location = Location.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
                @location = nil
            end
        end

        def location_params
            params.require(:location).permit(:name, :sort_name)
        end
end
