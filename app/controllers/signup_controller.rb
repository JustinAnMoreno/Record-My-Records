class SignupController < ApplicationController
  def create
#Define User
    user = User.new(user_params)
    if user.save
# Assign "user_id" to payload
      payload  = { user_id: user.id }
#JWT(JSON Web Token)
      session = JWTSessions::Session.new(
#JWT Sessions gem 
        payload: payload, 
        refresh_by_access_allowed: true)
      tokens = session.login

      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production? )
#CSRF (Cross-site Request Forgery Attack) Token                          
      render json: { csrf: tokens[:csrf] }
    else
      render json: { error: user.errors.full_messages.join(' ') }, 
      status: :unprocessable_entity
    end
  end

  private

# Create new User with email, password, confirmation parameters
  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end