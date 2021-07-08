class Citationterms::JournalsController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource
 
    before_action :require_login
    before_action :authenticate_user!
    before_action :set_journal, only: [:show, :edit, :update, :destroy, :references]

    layout 'bibliography'

    def index
        authorize! :read, Journal, :message => "Unable to load this page."

        @journals_grid = initialize_grid(Journal, 
            order:           'journals.normal_name',
            order_direction: 'asc'
        )

        @journals = Journal.all
    end

    def show
    end

    def new
        @journal = Journal.new
    end

    def edit
    end

    def create
        @journal = Journal.new(journal_params)

        authorize! :create, @journal, :message => "Unable to create this Journal record."

        @journal.created_by = current_user

        @journal.sort_name = @journal.name

        @journal.display_name = @journal.name

        if @journal.save
            respond_to do |format|
                format.html { redirect_to citationterms_journal_path(@journal), notice: 'Journal was successfully created.' }
                format.json { render :show, status: :created, location: @journal }
            end
        else
            respond_to do |format|
                format.html { render :new }
                format.json { render json: @journal.errors, status: :unprocessable_journal }
            end
        end
    end

    def update
        authorize! :update, @journal, :message => "Unable to update this Journal record."

        # copy over subject_params into period_attributes so we can alter it
        journal_attributes = journal_params

        # update modified_by
        journal_attributes[:modified_by] = current_user

        # fill in sort_name, display_name if they are empty
        if journal_attributes[:sort_name].empty?
            journal_attributes[:sort_name] = @journal.name
        end
        #if journal_attributes[:display_name].empty?
        #    journal_attributes[:display_name] = @journal.name
        #end

        if @journal.update(journal_attributes)
            respond_to do |format|
                format.html { redirect_to citationterms_journal_path(@journal), notice: 'Journal was successfully updated.' }
                format.json { render :show, status: :ok, location: @journal }
            end
        else
            respond_to do |format|
                format.html { render :edit }
                format.json { render json: @journal.errors, status: :unprocessable_journal }
            end
        end
    end

    def destroy
        authorize! :destroy, @journal, :message => "Unable to destroy this Journal record."

        @journal.destroy
        respond_to do |format|
            format.html { redirect_to citationterms_journals_path, notice: 'Journal was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def references
        @bibs_grid = initialize_grid(@journal.bib_refs) unless @journal.nil?
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_journal
            begin
                @journal = Journal.find(params[:id])
                authorize! :read, @journal, :message => "Unable to read this Journal record."
            rescue ActiveRecord::RecordNotFound => e
                @journal = nil
            end
        end

        def journal_params
            params.require(:journal).permit(:name, :sort_name, :display_name)
        end
end

