class ManageUsersController < ApplicationController
    protect_from_forgery with: :exception
    #load_and_authorize_resource

    before_action :require_login
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :edit, :update]

    layout 'bibliography'

    def index
        authorize! :read, 'ManageUsers', :message => "Unable to load this page."

        @role_message = "unknown role!"

        # order from least privileged to most privileged
        if current_user.assistant_editor_role?
            @role_message = "this user is an associate editor"
            @users_grid = initialize_grid(User,
                #conditions: {created_by: current_user.email},
                order:           'users.created_at',
                order_direction: 'desc'
            )
        elsif current_user.associate_editor_role?
            @role_message = "this user is an assistant editor"
            @users_grid = initialize_grid(User,
                #conditions: {created_by: current_user.email},
                order:           'users.created_at',
                order_direction: 'desc'
            )
        elsif current_user.admin_role?
            @role_message = "this user is an admin"
            @users_grid = initialize_grid(User,
                #conditions: {created_by: current_user.email},
                order:           'users.created_at',
                order_direction: 'desc'
            )
        end
    end

    def show
    end

    def edit
    end

    def update
    end

    private
        def set_user
            begin
                authorize! :read, 'ManageUsers', :message => "Unable to load this page."
                @user = User.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
                @user = nil
            end
        end
end
