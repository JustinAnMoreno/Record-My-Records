class RefreshController < ApplicationController
#refresh by access controller with cookies as token transport
    before_action :authorize_refresh_by_access_request!

    def create
        session = JWTSessions::Session.new(payload: claimless_payload,                 
            refresh_by_access_allowed: true)
        tokens = sesssion.refresh_by_access_allowed do
            raise JWTSession::Errors::Unauthorized, "Error"
        end


        response.set_cookie(JWTSessions.access_cookie,
                            value: tokens[:access],
                            httponly: true,
                            secure: Rails.env.production? )

        render json: { csrf: tokens[:csrf] }
        end
    end
