class ManageUsersController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource

    before_action :require_login
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :edit, :update]

    layout 'bibliography'

    def index
        authorize! :read, 'ManageUsers', :message => "Unable to load this page."

        # check current_user's permissions and select the roles that are available to set
        @roles_current_user_can_manage = generate_roles_current_user_can_manage

        if !@roles_current_user_can_manage.empty?
            @role_message = "current user role: #{current_user.role}"
            @users_grid = initialize_grid(User,
                conditions:      {role: @roles_current_user_can_manage},
                order:           'users.name',
                order_direction: 'asc'
            )
        end
    end

    def show
    end

    def edit
        @role_options = []
        if !@user.nil?
            # generate the array of roles for the edit screen options list
            @role_options = generate_role_options
        end

        @role_options
    end

    def update
        # copy over user_params into user_attributes so we can alter it
        user_attributes = user_params

        # HACK check that the new role submitted is included in @roles_current_user_can_manage
        if is_selected_role_valid?(@roles_current_user_can_manage, user_attributes[:role])
            if @user.update(user_attributes)
                respond_to do |format|
                    format.html { redirect_to manage_user_path(@user), notice: 'User was successfully updated.' }
                    format.json { render :show, status: :ok, location: @user }
                end
            else
                respond_to do |format|
                    # HACK reset all values for re-rendering
                    @old_user = @user.clone
                    set_user
                    @user.errors.merge!(@old_user.errors)

                    @role_options = generate_role_options
                    
                    format.html { render :edit }
                    format.json { render json: @user.errors, status: :unprocessable_user }
                end
            end
        else
             # TODO move this logic into model if possible
             # HACK reset all values for re-rendering
             @old_user = @user.clone
             set_user
             @user.errors.merge!(@old_user.errors)
 
             @role_options = generate_role_options
             respond_to do |format|
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

                # make sure we can access the selected user account.
                # this is based on cancancan ability settings.
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

            # create an array of roles the current_user can manage
            @roles_current_user_can_manage = generate_roles_current_user_can_manage
        end

        def generate_role_options
            # first, check that @roles_current_user_can_manage exists.
            # this method is called in the set_user before_action callback so it should already be active
            @roles_current_user_can_manage ||= generate_roles_current_user_can_manage

            user_role_index = User::USER_ROLES.index(@user.role.to_sym)

            select_roles = []

            # loop through list of roles the current_user can manage and generate an options list for the edit form
            @roles_current_user_can_manage.each do |role|
                my_role_index = User::USER_ROLES.index(role)
                label = "#{role.to_s.sub("_", " ").capitalize} #{get_role_rank_string(user_role_index, my_role_index)}"
                select_roles << [label, role]
            end

            select_roles
        end

        # check cancancan abilitites to determine which roles the current_user can access
        def generate_roles_current_user_can_manage 
            roles = []
            if can? :manage, 'Associates'
                roles << :associate_editor
            end
            if can? :manage, 'Assistants'
                roles << :assistant_editor
            end
            if can? :manage, 'Correspondents'
                roles << :correspondent
            end
            if can? :manage, 'Standards'
                roles << :standard
            end
            #if can? :manage, 'Guests'
            #    roles << :guest
            #end

            roles
        end

        # generate string that displays up or down arrows to indicate the rank of all other roles  
        # relative to the selected user's role
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

        # check if the role selected by the user is within the list of possible roles allowed
        def is_selected_role_valid?(managed_roles, selected_role)
            # TODO sanity check params
            if managed_roles.include?(selected_role.to_sym) 
                return true
            else
                @user.errors.add(:role, "must be selected from the options given")
                return false
            end
        end

        def user_params
            params.require(:user).permit(:role)
        end
end
