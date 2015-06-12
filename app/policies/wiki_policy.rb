class WikiPolicy < ApplicationPolicy
  def show?
    scope.exists?(record.id)
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

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.public_wikis unless user
      user.list_accessible_wikis
    end
  end
end