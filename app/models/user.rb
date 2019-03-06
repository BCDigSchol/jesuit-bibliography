class User < ApplicationRecord
  before_validation :set_default_role

  validates :role, presence: true
  validates :name, presence: true
  validates :email, presence: true
  validate :uses_known_user_roles

  # role is defined as an int
  #             0       1                  2                  3               4          5
  USER_ROLES = [:admin, :associate_editor, :assistant_editor, :correspondent, :standard, :guest].freeze

  # descriptions of role types
  ADMIN_ROLE_DESCRIPTION = "The admin role can manage all aspects of the site.".freeze
  ASSOCIATE_EDITOR_ROLE_DESCRIPTION = "The Associate editor role can create, edit and publish any records. This role can also manage internal term lists, including suggested terms.".freeze
  ASSISTANT_EDITOR_ROLE_DESCRIPTION = "The Assistant editor role can create and edit all citation records, but not publish any records. This role can also view internal term lists.".freeze
  CORRESPONDENT_ROLE_DESCRIPTION = "The Correspondent/contributor role can create citation records, and can edit their own records until an editor sets the record to a 'published' status.".freeze
  STANDARD_ROLE_DESCRIPTION = "The standard role can only use the public search interface, but does not have access to submit or edit citation records.".freeze

  enum role: USER_ROLES

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :name, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def get_role_name
    if self.role.present?
      self.role.sub("_", " ").capitalize
    else
      ""
    end
  end

  def admin_role?
    self.is_role? "admin"
  end

  def is_role? (role_given)
    self.role == role_given
  end

  # not implemented
  def check_if_can_alter_role(good_roles, given_role)
    errors.add(:role, "is not a role that is valid") unless good_roles.include?(given_role.to_sym)
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

    # sanity check to make sure we're not assigning roles to an arbitrary string
    def uses_known_user_roles
      errors.add(:role, "is not a valid choice") unless USER_ROLES.include?(self.role.to_sym)
    end
end
