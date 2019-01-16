module ManageUsersHelper
    # pretty-print role name
    def role_pretty_display(role)
        case role
        when Symbol
            role.to_s.sub("_", " ").capitalize
        when String
            role.sub("_", " ").capitalize
       end
    end
end
