class User < ApplicationRecord

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :name, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def get_role_name
    role_name = ""

    # role_name is determined by the highest role assigned
    if self.admin_role?
      role_name = "Administator"
    elsif self.associate_editor_role?
      role_name =  "Associate Editor"
    elsif self.assistant_editor_role?
      role_name =  "Assistant Editor"
    elsif self.correspondent_role?
      role_name = "Correspondent"
    elsif self.guest?
      role_name = "Guest"
    else
      role_name = "None"
    end

    role_name
  end
end
