# Model class for users table
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :wikis, dependent: :destroy
  has_many :colaborators, dependent: :destroy

  def create_private_wikis?
    %w(admin premium).include?(role)
  end

  # Public: Determins if the user is an admin
  #
  # Returns true if user is an admin and false otherwise
  def admin?
    role == 'admin'
  end

  # Public: List all the wikis the user has access to
  #
  # Examples
  #
  #   User.find(1).list_accessible_wikis
  #   # => ['wikis the', 'user has', 'access to']
  #
  # Returns an ActiveRecord::Relation of wiki objects the user has access to
  def list_accessible_wikis
    case role
    when 'admin'
      Wiki.all
    when 'premium'
      premium_user_wikis
    when 'standard'
      standard_user_wikis
    end
  end

  private

  # Private: Get all wikis that a premium user has access to
  #
  # Returns an ActiveRecord::Relation of wiki objects
  def premium_user_wikis
    Wiki.wikis_with_colaborators
      .where('private = ? OR wikis.user_id = ? OR colaborators.user_id = ?',
             false, id, id)
  end

  # Private: Get all wikis that a standard user has access to
  #
  # Returns an ActiveRecord::Relation of wiki objects
  def standard_user_wikis
    Wiki.wikis_with_colaborators
      .where('private = ? OR colaborators.user_id = ?', false, id)
  end
end
