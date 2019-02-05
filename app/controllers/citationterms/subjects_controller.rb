class Citationterms::SubjectsController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource

    before_action :require_login
    before_action :authenticate_user!
    before_action :set_subject, only: [:show, :edit, :update, :destroy]

    layout 'bibliography'

    def index
        authorize! :read, Subject, :message => "Unable to load this page."

        @subjects_grid = initialize_grid(Subject, 
            order:           'subjects.name',
            order_direction: 'asc'
        )

        @subjects = Subject.all
    end
    
    def new
        @subject = Subject.new
    end

    def show
    end

    def edit
        @bibs = @subject.bibliographies.count
    end

    def create
        @subject = Subject.new(subject_params)

        authorize! :create, @subject, :message => "Unable to create this Subject record."

        @subject.created_by = current_user

        @subject.sort_name = @subject.name

        if @subject.save
            respond_to do |format|
                format.html { redirect_to citationterms_subject_path(@subject), notice: 'Subject was successfully created.' }
                format.json { render :show, status: :created, location: @subject }
            end
        else
            respond_to do |format|
                format.html { render :new }
                format.json { render json: @subject.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        authorize! :update, @subject, :message => "Unable to update this Subject record."

        # copy over subject_params into subject_attributes so we can alter it
        subject_attributes = subject_params

        # update modified_by
        subject_attributes[:modified_by] = current_user

        # fill in sort_name if it is empty
        if subject_attributes[:sort_name].empty?
            subject_attributes[:sort_name] = @subject.name
        end

        if @subject.update(subject_attributes)
            respond_to do |format|
                format.html { redirect_to citationterms_subject_path(@subject), notice: 'Subject was successfully updated.' }
                format.json { render :show, status: :ok, location: @subject }
            end
        else
            respond_to do |format|
                format.html { render :edit }
                format.json { render json: @subject.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        authorize! :destroy, @subject, :message => "Unable to destroy this Subject record."

        @subject.destroy
        respond_to do |format|
            format.html { redirect_to citationterms_subjects_path, notice: 'Subject was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_subject
            begin
                @subject = Subject.find(params[:id])
                authorize! :read, @subject, :message => "Unable to read this Subject record."
            rescue ActiveRecord::RecordNotFound => e
                @subject = nil
            end
        end

        def subject_params
            params.require(:subject).permit(:name, :sort_name)
        end
end
