class RoomPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.with_role([:owner, :access], user)
    end
  end

  def index?
    true
  end

  def show?
    record.public || user.has_any_role?({name: :owner, resource: record}, {name: :access, resource: record})
  end

  def new?
    true
  end

  def edit?
    user.has_role?(:owner, record)
  end

  def create?
    true
  end

  def update?
    user.has_role?(:owner, record)
  end

  def destroy?
    user.has_role?(:owner, record)
  end

  def create_public?
    !user.guest
  end
end
