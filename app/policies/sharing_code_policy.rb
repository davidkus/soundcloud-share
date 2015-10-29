class SharingCodePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    user.has_role?(:owner, record.room)
  end

  def new?
    user.has_role?(:owner, record.room)
  end

  def create?
    user.has_role?(:owner, record.room)
  end

  def destroy?
    user.has_role?(:owner, record.room)
  end
end
