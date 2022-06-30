module Api
    module V0
        class SessionsController < ApplicationController

            def create
                user = User.find_by(email: params[:user][:email])
                if user && user.authenticate(params[:user][:password])
                    session[:user_id] = user.id
                    render json: {message: "authenticated"}
                else
                    render json: "aiueo", status: 200
                end
            

            end
        end
    end
end
