class AddDeviseUsers < ActiveRecord::Migration[5.2]
    def change
      # Initialize admin account:
      User.create! do |u|
        u.email     = 'admin@test.com'
        u.password    = 'password'
        u.admin_role = true
      end

      # Initialize editor account:
      User.create! do |u|
        u.email     = 'editor@test.com'
        u.password    = 'password'
        u.editor_role = true
      end

      # Initialize collaborator account:
      User.create! do |u|
        u.email     = 'collaborator@test.com'
        u.password    = 'password'
        u.collaborator_role = true
      end

      # Initialize user account:
      User.create! do |u|
        u.email     = 'user@test.com'
        u.password    = 'password'
      end
    end
  end  