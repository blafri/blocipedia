# Model class for the wikis table
class Wiki < ActiveRecord::Base
  validate :private_wiki_cannot_be_created_by_standard_users

  before_update :delete_colaborators,
  if: Proc.new { |wiki| wiki.private_changed?(from: true, to: false) }

  belongs_to :user
  has_many :colaborators, dependent: :destroy
  has_many :users, through: :colaborators

  validates :title, presence: true
  validates :body, presence: true

  # Public: Gets a list of all public wikis
  #
  # Examples
  #
  #   Wiki.public_wikis
  #   # => ['ActiveRecord::Relation of wikis ', 'of public wikis']
  #
  # Returns an ActiveRecord::Relation of wiki objects that are public
  scope :public_wikis, -> { where(private: false) }

  # Public: joins the wikis table with the colaborators table
  #
  # Returns an ActiveRecord::Relation of the wikis table left joined with the
  #         colaborators table
  def self.wikis_with_colaborators
    joins('LEFT JOIN colaborators ON colaborators.wiki_id = wikis.id')
  end

  # Public: lists wikis that the provided user has access to. Public wikis are
  #         accessible to everyone and private wikis are accessible to the owner
  #         of the wiki and the wikis colaborators
  #
  # Returns an ActiveRecord::Relation of wiki objects the given user has access
  #         to
  def self.visable(user = nil)
    return public_wikis unless user

    case user.role
    when "admin"
      all
    when "premium"
      premium_user_wikis(user.id)
    when "standard"
      standard_user_wikis(user.id)
    end
  end
  # Public: Gets a list of all wikis that are private for the passed in user.
  #
  # user - The user Object for which you want to get the list of private wikis.
  #
  # Examples
  #   Wiki.list_private_wikis_for(user)
  #   # => An array of private wikis that the user owns
  #
  # Returns an Array of private wikis for the user
  scope :list_private_wikis_for, -> (user) { where(user: user, private: true) }

  # Public: Sets the private attribute of all wikis of the specified user to
  #         false and also removes all the wikis colaborators. This method is
  #         used when downgrading a users account
  #
  # user - The user object for the user whos wikis will be downgraded
  def self.user_wikis_to_public(user)
    wikis = list_private_wikis_for(user)
    colaborators = Colaborator.where(wiki_id: wikis.pluck(:id))
    wikis.update_all(private: false)
    colaborators.delete_all
  end

  private

  # Internal: Validates that only premium or admin users can create private
  #           wikis
  def private_wiki_cannot_be_created_by_standard_users
    if self.private == true && user.create_private_wikis? == false
      errors.add(:private, 'wikis cannot be created by a standard user')
    end
  end

  # Internal: Deletes colaborators on a wiki. Used when a wiki is changed from
  #           private to public to delete colaborators
  def delete_colaborators
    Colaborator.where(wiki_id: id).delete_all
  end

  # Private: Get all wikis that a premium user has access to
  #
  # Returns an ActiveRecord::Relation of wiki objects
  def self.premium_user_wikis(user_id)
    wikis_with_colaborators
      .where('private = ? OR wikis.user_id = ? OR colaborators.user_id = ?',
             false, user_id, user_id)
  end

  # Private: Get all wikis that a standard user has access to
  #
  # Returns an ActiveRecord::Relation of wiki objects
  def self.standard_user_wikis(user_id)
    wikis_with_colaborators
    .where('private = ? OR colaborators.user_id = ?', false, user_id)
  end
end
