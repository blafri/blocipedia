class WikiPolicy < ApplicationPolicy
  def show?
    scope.where(:id => record.id).exists? && (user.present? || !record.private)
  end
  
  def create?
    user.present?
  end
  
  def update?
    user.present?
  end
  
  def destroy?
    user.present? && record.user == user
  end
end