# Model class for the wikis table
class Wiki < ActiveRecord::Base
  validate :private_wiki_cannot_be_created_by_standard_users

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
  #
  # Examples
  #
  #   Wiki.user_wikis_to_public(user)
  #
  # Returns true if successful or false if unsuccessful
  def self.user_wikis_to_public(user)
    wikis = list_private_wikis_for(user)
    colaborators = Colaborator.where(wiki: wikis)
    colaborators.delete_all
    wikis.update_all(private: false)
  end

  private

  # Internal: Validates that only premium or admin users can create private
  #           wikis
  def private_wiki_cannot_be_created_by_standard_users
    if self.private == true && user.create_private_wikis? == false
      errors.add(:private, 'wikis cannot be created by a standard user')
    end
  end
end
