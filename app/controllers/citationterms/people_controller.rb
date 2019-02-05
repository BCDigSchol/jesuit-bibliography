class Citationterms::PeopleController < ApplicationController

    protect_from_forgery with: :exception
    #load_and_authorize_resource
    
    before_action :require_login
    before_action :authenticate_user!
    before_action :set_person, only: [:show, :edit, :update, :destroy]

    layout 'bibliography'

    def index
        authorize! :read, Person, :message => "Unable to load this page."

        @people_grid = initialize_grid(Person, 
            order:           'people.sort_name',
            order_direction: 'asc'
        )

        @persons = Person.all
    end

    def show
    end

    def new
        @person = Person.new
    end

    def edit
        @bibs = get_people_records
    end

    def create
        @person = Person.new(person_params)

        authorize! :create, @person, :message => "Unable to create this Person record."

        @person.created_by = current_user

        @person.sort_name = @person.name

        @person.display_name = @person.name

        if @person.save
            respond_to do |format|
                format.html { redirect_to citationterms_person_path(@person), notice: 'Person was successfully created.' }
                format.json { render :show, status: :created, location: @person }
            end
        else
            respond_to do |format|
                format.html { render :new }
                format.json { render json: @person.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        authorize! :update, @person, :message => "Unable to update this Person record."

        # copy over subject_params into person_attributes so we can alter it
        person_attributes = person_params

        # update modified_by
        person_attributes[:modified_by] = current_user

        # fill in sort_name, display_name if they are empty
        if person_attributes[:sort_name].empty?
            person_attributes[:sort_name] = @person.name
        end
        #if person_attributes[:display_name].empty?
        #    person_attributes[:display_name] = @person.name
        #end

        if @person.update(person_attributes)
            respond_to do |format|
                format.html { redirect_to citationterms_person_path(@person), notice: 'Person was successfully updated.' }
                format.json { render :show, status: :ok, location: @person }
            end
        else
            respond_to do |format|
                format.html { render :edit }
                format.json { render json: @person.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        authorize! :destroy, @person, :message => "Unable to destroy this Person record."

        @person.destroy
        respond_to do |format|
            format.html { redirect_to citationterms_people_path, notice: 'Person was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_person
            begin
                @person = Person.find(params[:id])
                authorize! :read, @person, :message => "Unable to read this Person record."
            rescue ActiveRecord::RecordNotFound => e
                @person = nil
            end
        end

        def get_people_records
            #people = []
            #people << @person.authors if @person.authors.present?
            #people << @person.editors if @person.editors.present?
            #people << @person.book_editors if @person.book_editors.present?
            #people << @person.performers if @person.performers.present?
            #people << @person.author_of_reviews if @person.author_of_reviews.present?
            #people << @person.translators if @person.translators.present?
            #people

            total_instances =  @person.authors.length + @person.editors.length + @person.book_editors.length + @person.performers.length + @person.author_of_reviews.length + @person.translators.length

            total_instances
        end

        def person_params
            params.require(:person).permit(:name, :sort_name, :display_name, :surname, :middlename, :forename, :title)
        end
end
