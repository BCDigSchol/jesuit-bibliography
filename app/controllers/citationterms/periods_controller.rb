class Citationterms::PeriodsController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource
 
    before_action :require_login
    before_action :authenticate_user!
    before_action :set_period, only: [:show, :edit, :update, :destroy, :references]

    layout 'bibliography'

    def index
        authorize! :read, Period, :message => "Unable to load this page."

        @periods_grid = initialize_grid(Period, 
            order:           'periods.normal_name',
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

        authorize! :create, @period, :message => "Unable to create this Period record."

        @period.created_by = current_user

        @period.sort_name = @period.name

        if @period.save
            respond_to do |format|
                format.html { redirect_to citationterms_period_path(@period), notice: 'Period was successfully created.' }
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
        authorize! :update, @period, :message => "Unable to update this Period record."

        # copy over subject_params into period_attributes so we can alter it
        period_attributes = period_params

        # update modified_by
        period_attributes[:modified_by] = current_user

        # fill in sort_name if it is empty
        if period_attributes[:sort_name].empty?
            period_attributes[:sort_name] = @period.name
        end

        if @period.update(period_attributes)
            respond_to do |format|
                format.html { redirect_to citationterms_period_path(@period), notice: 'Period was successfully updated.' }
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
        authorize! :destroy, @period, :message => "Unable to destroy this Period record."

        @period.destroy
        respond_to do |format|
            format.html { redirect_to citationterms_periods_path, notice: 'Period was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def references
        @bibs_grid = initialize_grid(@period.bib_refs)
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_period
            begin
                @period = Period.find(params[:id])
                authorize! :read, @period, :message => "Unable to read this Period record."
            rescue ActiveRecord::RecordNotFound => e
                @period = nil
            end
        end

        def period_params
            params.require(:period).permit(:name, :sort_name)
        end
end
