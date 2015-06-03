class Wiki < ActiveRecord::Base
  validate :private_wiki_cannot_be_created_by_standard_users
  
  belongs_to :user
  
  validates :title, presence: true
  validates :body,  presence: true
  
  # Public: Gathers an array of wikis from the database that the user can access
  #         If the user is logged in he will see all wikis. If he is logged out
  #         He will only see wikis that are not private
  #
  # user - The user Object to get the list of wikis that he can see. If it is
  #        nil only wikis that are not private will be returned. If it is a
  #        valid user object all wikis will be returned
  #
  # Examples
  #
  #   Wiki.wikis_visable_to(user)
  #   # => ['Array of wikis ', 'that the user has ', 'access to']
  #
  # Returns an Array of wiki objects that the user can view
  scope :wikis_visable_to, -> (user) { user ? all : where(private: false) }
  
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
  #         false. This method is used when downgrading a users account
  #
  # user - The user object for the user whos wikis will be downgraded
  #
  # Examples
  #
  #   Wiki.user_wikis_to_public(user)
  #
  # Returns an Array of wikis that were changed to public
  def self.user_wikis_to_public(user)
    wikis = list_private_wikis_for(user)
    wikis.each { |wiki| wiki.update(private: false) }
  end
  
  private
  
  # Internal: Validates that only premium or admin users can create private
  #           wikis 
  def private_wiki_cannot_be_created_by_standard_users
    if private == true && user.create_private_wikis? == false
      errors.add(:private, "wikis cannot be created by a standard user")
    end
  end
end
