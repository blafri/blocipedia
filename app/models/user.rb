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
end
