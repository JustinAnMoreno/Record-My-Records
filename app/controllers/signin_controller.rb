#inheriting from ApplicationController
class SigninController < ApplicationController
     #Authenticate User (JWT GEM)
  before_action :authorize_access_request!, only: [:destroy]

  def create
    #Search for user through email address
    user = User.find_by!(email: params[:email])
    if user.authenticate(params[:password])
      payload = { user_id: user.id }
      #Requests new sign in on refresh if session times out
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login
      response.set_cookie(JWTSessions.access_cookie,
                        value: tokens[:access],
                        httponly: true,
                        secure: Rails.env.production?)
      render json: { csrf: tokens[:csrf] }
    else
      not_authorized
    end
  end
#Logout 
  def destroy
    session = JWTSessions::Session.new(payload: payload)
#flush one session inside a namespace by its access token    
    session.flush_by_access_payload
    render json: :ok
  end

  private
 #Error message for missing email/password combination 
  def not_found
    render json: { error: "Cannot find email/password combination" }, status: :not_found
  end
end



