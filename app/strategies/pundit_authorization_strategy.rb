class PunditAuthorizationStrategy < DecentExposure::StrongParametersStrategy
  delegate :authorize, :policy_scope, to: :controller

  def collection_resource
    policy_scope super
  end

  def resource
    super.tap { |r| authorize r }
  end
end
