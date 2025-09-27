# frozen_string_literal: true

module TokenGenerator
  include JwtToken

  def jwt_token(user)
    jwt_encode({ user_id: user.id })
  end
end
