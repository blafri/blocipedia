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
      scope.visable(user)
    end
  end
end