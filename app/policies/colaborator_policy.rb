class ColaboratorPolicy < ApplicationPolicy
  def show?
    false
  end

  # Public: Verifies if the colaborator can be added. To be added the wiki the
  #         colaborator is for must be a private wiki and the user adding the
  #         colaborator must b the owner of the wiki.
  # Returs a boolean value indicating if the colaborator can be added
  def create?
    record.wiki.private? &&  user == record.wiki.user
  end

  def new?
    false
  end

  # Public: Verifies if the user has access to delete the colaborator for this
  #         wiki. To delete colaborators you must own the wiki
  def destroy?
    user = record.wiki.user
  end
end