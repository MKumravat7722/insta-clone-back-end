module TokenGenerator
  include JwtToken
  def jwt_token_1(user)
    jwt_encode({ user_id: user.id })
  end
end
