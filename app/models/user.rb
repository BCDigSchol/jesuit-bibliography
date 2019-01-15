class User < ApplicationRecord
  before_create :set_default_role

  # role is defined as an int
  #             0       1                  2                  3               4          5
  USER_ROLES = [:admin, :associate_editor, :assistant_editor, :correspondent, :standard, :guest].freeze

  enum role: USER_ROLES

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
    self.role.sub("_", " ").capitalize
  end

  def admin_role?
    self.is_role? "admin"
  end

  def is_role? (role_given)
    self.role == role_given
  end

  private
    def set_default_role
      # if our "guest" flag is set to 'true' then assign a role of 'guest'
      if self.guest == true
        self.role = :guest
      else
        self.role ||= :standard
      end
    end
end
