# frozen_string_literal: true

module ApiHelper
  def authenticate_request!(request, user)
    token = JsonWebToken.encode(user_id: user.id)
    request.headers.merge!('Authorization': "Bearer #{token}")
  end
end
