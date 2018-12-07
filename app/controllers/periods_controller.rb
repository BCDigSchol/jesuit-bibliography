class PeriodsController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource
 
    before_action :require_login
    before_action :authenticate_user!
    before_action :set_period, only: [:show, :edit, :update, :destroy]

    layout 'bibliography'

    def index
        @periods_grid = initialize_grid(Period, 
            order:           'periods.name',
            order_direction: 'asc'
        )

        @periods = Period.all
    end

    def show
    end

    def new
        @period = Period.new
    end

    def edit
    end

    def create
        @period = Period.new(period_params)

        if @period.save
            respond_to do |format|
                format.html { redirect_to @period, notice: 'Period was successfully created.' }
                format.json { render :show, status: :created, location: @period }
            end
        else
            respond_to do |format|
                format.html { render :new }
                format.json { render json: @period.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        if @period.update!(period_params)
            #@comments = @bib.comments
            respond_to do |format|
                format.html { redirect_to @period, notice: 'Period was successfully updated.' }
                format.json { render :show, status: :ok, location: @period }
            end
        else
            respond_to do |format|
                format.html { render :edit }
                format.json { render json: @period.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @period.destroy
        respond_to do |format|
            format.html { redirect_to periods_path, notice: 'Period was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_period
            begin
                @period = Period.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
                @period = nil
            end
        end

        def period_params
            params.require(:period).permit(:name, :sort_name)
        end
end
