class SubjectsController < ApplicationController
    protect_from_forgery with: :exception

    before_action :authenticate_user!
    before_action :set_subject, only: [:show, :edit, :update, :destroy]

    layout 'bibliography'

    def index
        @subjects = Subject.all
    end
    
    def new
        @subject = Subject.new
    end

    def show
    end

    def edit
    end

    def create
        @subject = Subject.new(subject_params)

        if @subject.save
            respond_to do |format|
                format.html { redirect_to @subject, notice: 'Subject was successfully created.' }
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
        if @subject.update!(subject_params)
            respond_to do |format|
                format.html { redirect_to @subject, notice: 'Subject was successfully updated.' }
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
        @subject.destroy
        respond_to do |format|
            format.html { redirect_to subjects_path, notice: 'Subject was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_subject
            begin
                @subject = Subject.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
                @subject = nil
            end
        end

        def subject_params
            params.require(:subject).permit(:term_type, :name)
        end
end
