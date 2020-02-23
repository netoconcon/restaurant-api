class RestaurantPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def create?
    # any logged user can create a restaurant
    !user.nil?
    # any logged user who is not disable
    # user.disable = false
  end

  def update?
    # only restaurant owner can update it
    record.user == user
  end

  def destroy?
    update? # same authorization of update
  end
end
