# Model class for colaborators table
class Colaborator < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki

  validates :wiki, presence: true
  validates :user, presence: true
  validates :user_id, uniqueness: { scope: :wiki_id,
                                    message: 'is already a colaborator' }
end
