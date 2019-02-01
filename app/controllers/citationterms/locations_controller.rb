class Citationterms::LocationsController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource
 
    before_action :require_login
    before_action :authenticate_user!
    before_action :set_location, only: [:show, :edit, :update, :destroy]

    layout 'bibliography'

    def index
        authorize! :read, Location, :message => "Unable to load this page."

        @locations_grid = initialize_grid(Location, 
            order:           'locations.name',
            order_direction: 'asc'
        )

        @locations = Location.all
    end

    def show
    end

    def new
        @location = Location.new
    end

    def edit
        @bibs = @location.bibliographies
    end

    def create
        @location = Location.new(location_params)

        authorize! :create, @location, :message => "Unable to create this Location record."

        @location.created_by = current_user

        @location.sort_name = @location.name

        if @location.save
            respond_to do |format|
                # url: citationterms_location_path, action: show, id: @location.id
                format.html { redirect_to citationterms_location_path(@location), notice: 'Location was successfully created.' }
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
        authorize! :update, @location, :message => "Unable to update this Location record."

        # copy over subject_params into location_attributes so we can alter it
        location_attributes = location_params

        # update modified_by
        location_attributes[:modified_by] = current_user

        # fill in sort_name if it is empty
        if location_attributes[:sort_name].empty?
            location_attributes[:sort_name] = @location.name
        end

        if @location.update(location_attributes)
            respond_to do |format|
                format.html { redirect_to citationterms_location_path(@location), notice: 'Location was successfully updated.' }
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
        authorize! :destroy, @location, :message => "Unable to destroy this Location record."

        @location.destroy
        respond_to do |format|
            format.html { redirect_to citationterms_locations_path, notice: 'Location was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_location
            begin
                @location = Location.find(params[:id])
                authorize! :read, @location, :message => "Unable to read this Location record."
            rescue ActiveRecord::RecordNotFound => e
                @location = nil
            end
        end

        def location_params
            params.require(:location).permit(:name, :sort_name)
        end
end
