class ManageUsersController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource

    before_action :require_login
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :edit, :update]

    layout 'bibliography'

    def index
        authorize! :read, 'ManageUsers', :message => "Unable to load this page."

        conditional_roles = selectable_roles

        if !conditional_roles.empty?
            @role_message = "current user role: #{current_user.role}"
            @users_grid = initialize_grid(User,
                conditions:      {role: conditional_roles},
                order:           'users.name',
                order_direction: 'asc'
            )
        end
    end

    def show
    end

    def edit
        @select_roles = []
        if !@user.nil?
            puts "\n\nHERE! user is NOT nil\n\n"
            @select_roles = generate_selected_roles
        else 
            puts "\n\nHERE! user is nil\n\n"
            @select_roles << "foo"
        end

        @select_roles
    end

    def update
        # copy over user_params into user_attributes so we can alter it
        user_attributes = user_params

        select_from_roles = selectable_roles

        #@user.check_if_can_alter_role(select_from_roles, "foo".to_sym)

        # check that the new role submitted is inside the list of roles this user can manage
        # TODO move validation logic into model
      
        if @user.update(user_attributes)
            respond_to do |format|
                format.html { redirect_to manage_user_path(@user), notice: 'User was successfully updated.' }
                format.json { render :show, status: :ok, location: @user }
            end
        else
            puts "\n\nSomething wasn't right\n\n"
            respond_to do |format|
                # reset all values for re-rendering
                set_user
                @select_roles = generate_selected_roles
                
                format.html { render :edit }
                format.json { render json: @user.errors, status: :unprocessable_user }
            end
        end
    end

    private
        def set_user
            begin
                authorize! :read, 'ManageUsers', :message => "Unable to load this page."
                grab_user = User.find(params[:id])

                if can? :manage, 'Associates' and grab_user.is_role? "associate_editor"
                    @user = grab_user
                elsif can? :manage, 'Assistants' and grab_user.is_role? "assistant_editor"
                    @user = grab_user
                elsif can? :manage, 'Correspondents' and grab_user.is_role? "correspondent"
                    @user = grab_user
                elsif can? :manage, 'Standards' and grab_user.is_role? "standard"
                    @user = grab_user
                else 
                    @user = nil
                end
            rescue ActiveRecord::RecordNotFound => e
                @user = nil
            end
        end

        def generate_selected_roles
            select_roles = []
            # get the index of the user's role from USER_ROLES
            user_role_index = User::USER_ROLES.index(@user.role.to_sym)

            # For each of the roles the current_user can manage, collect the roles for the view dropdown
            if can? :manage, 'Associates'
                my_role_index = User::USER_ROLES.index(:associate_editor) #1
                label = "Associate Editor #{get_role_rank_string(user_role_index, my_role_index)}"
                select_roles << [label, :associate_editor]
            end
            if can? :manage, 'Assistants'
                my_role_index = User::USER_ROLES.index(:assistant_editor) #2
                label = "Assistant Editor #{get_role_rank_string(user_role_index, my_role_index)}"
                select_roles << [label, :assistant_editor]
            end
            if can? :manage, 'Correspondents'
                my_role_index = User::USER_ROLES.index(:correspondent) #3
                label = "Correspondent #{get_role_rank_string(user_role_index, my_role_index)}"
                select_roles << [label, :correspondent]
            end
            if can? :manage, 'Standards'
                my_role_index = User::USER_ROLES.index(:standard) #4
                label = "Standard #{get_role_rank_string(user_role_index, my_role_index)}"
                select_roles << [label, :standard]
            end

            my_role_index = User::USER_ROLES.index(:guest) #5
            label = "Guest #{get_role_rank_string(user_role_index, my_role_index)}"
            select_roles << [label, :guest]

            select_roles
        end

        def selectable_roles 
            # check cancancan abilitites to determine which user accounts to grab
            select_from_roles = []
            if can? :manage, 'Associates'
                select_from_roles << :associate_editor
            end
            if can? :manage, 'Assistants'
                select_from_roles << :assistant_editor
            end
            if can? :manage, 'Correspondents'
                select_from_roles << :correspondent
            end
            if can? :manage, 'Standards'
                select_from_roles << :standard
            end

            select_from_roles
        end

        def check_user_role_permission
            # get a list of roles that the current_user can manage
            select_from_roles = selectable_roles

            # check that the new role submitted is inside the list of roles this user can manage
            if !select_from_roles.include? :role
                errors.add(:role, :not_valid, message: "This is not a valid role for this user")
            end
        end

        def get_role_rank_string(user_role_index, given_role_index)
            unless user_role_index.is_a? Integer and user_role_index >= 0 and given_role_index.is_a? Integer and given_role_index >= 0
                return nil
            end

            rank_string = ""
            if user_role_index >= given_role_index
                rank = user_role_index - given_role_index
                if rank > 0
                    rank_string = "(#{'↑' * rank})"
                end
            else
                rank = given_role_index - user_role_index
                if rank > 0
                    rank_string = "(#{'↓' * rank})"
                end
            end

            rank_string
        end

        def user_params
            params.require(:user).permit(:role)
        end
end
