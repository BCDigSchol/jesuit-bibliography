class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here.:
    #
    user ||= User.new # guest user (not logged in)

    # Role can:
    #   Everything
    #if user.admin_role?
    if user.is_role? "admin"
      can :manage, :all
      can :access, :rails_admin     # only allow admin users to access Rails Admin
    end

    # Role can:
    #   Access Dashboard
    #   Manage all Bib records
    #   Manage all term records
    #   Mark approve Bib records as reviewed
    #   Manage Assistant Editor/Correspondent/Standard user accounts
    #   Manage Terms
    #   Manage Status
    #   Manage setting a record to 'Publish' status
    #   Manage Suggestions
    #   Manage RecordLinking
    #   Manage Tags
    #if user.associate_editor_role?
    if user.is_role? "associate_editor"
      can :read, 'ManageUsers'      # manage users
      can :manage, 'Assistants'     # manage assistant editors user accounts
      can :manage, 'Correspondents' # manage correspondent user accounts
      can :manage, 'Standards'      # manage stanard user accounts
      can :read, 'Dashboard'        # allow access to dashboard
      can :approve, Bibliography    # can approve record for publication
      can :manage, 'Terms'          # can access Term lists dropdown
      can :manage, 'Status'         # can manage record Status value
      can :manage, 'Publish'        # can set a record to 'published' status
      can :manage, 'Suggestions'    # can manage Suggestions
      can :manage, 'RecordLinking'  # can manage linking records together
      can :manage, Location         # can manage Location Term lists
      can :manage, Subject          # can manage Subject Term lists
      can :manage, Period           # can manage Period Term lists
      can :manage, Entity           # can manage Entity Term lists
      can :manage, Language         # can read Language Term lists
      can :manage, Person           # can read Language Term lists
      can :manage, Journal          # can read Journal Term lists
      can :manage, Bibliography     # can manage Bib records
      can :manage, Tag              # can manage Bib record Tags
    end

    # Role can:
    #   Access Dashboard
    #   Read/Update/Create Bib records (not destroy)
    #   Manage Correspondents/Standard accounts
    #   Manage Terms
    #   Manage Status
    #   Manage Suggestions
    #   Manage RecordLinking
    #   Manage Tags
    #if user.assistant_editor_role?
    if user.is_role? "assistant_editor"
      can :read, 'ManageUsers'                      # manage users
      can :manage, 'Correspondents'                 # manage correspondent user accounts
      can :manage, 'Standards'                      # manage stanard user accounts
      can :read, 'Dashboard'                        # allow access to dashboard
      can :manage, 'Terms'                          # can access Term lists dropdown
      can :manage, 'Status'                         # can manage record Status value
      can :manage, 'RecordLinking'                  # can manage linking records together
      can :manage, 'Suggestions'                    # can manage Suggestions
      can :read, Location                           # can read Location Term lists
      can :read, Subject                            # can read Subject Term lists
      can :read, Period                             # can read Period Term lists
      can :read, Entity                             # can read Entity Term lists
      can :read, Language                           # can read Language Term lists
      can :read, Person                             # can read Person Term lists
      can :read, Journal                            # can read Journal Term lists
      can [:create, :read, :update], Bibliography   # can create/read/update Bib records
      can :manage, Tag                              # can manage Bib record Tags
    end

    # Role can:
    #   Access Dashboard
    #   Create Bib records
    #if user.correspondent_role?
    if user.is_role? "correspondent"
      can :read, 'Dashboard'        # allow access to dashboard
      can :create, Bibliography     # can create a new Bib record
    end

    #if user.supervisor_role?
    #  can :manage, User
    #end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
