module Api
    module V0
        class SessionsController < ApplicationController
            def index
                if session[:user_id] && User.find_by(id: session[:user_id])
                    render json: { isLoggedIn: true }
                else
                    render json: { isLoggedIn: false }
                end
            end
            
            def create
                user = User.find_by(email: params[:user][:email])
                if user && user.authenticate(params[:user][:password])
                    session[:user_id] = user.id
                    render json: {message: "authenticated"}
                else
                    render json: {message: "パスワードまたはメールアドレスが正しくありません"}, status: :bad_request
                end
            end

            def logout
                session.delete(:user_id)
            end
        end
    end
end
