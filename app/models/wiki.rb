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
  
  private
  
  # Internal: Validates that only premium or admin users can create private
  #           wikis 
  def private_wiki_cannot_be_created_by_standard_users
    if private == true && user.create_private_wikis? == false
      errors.add(:private, "wikis cannot be created by a standard user")
    end
  end
end
