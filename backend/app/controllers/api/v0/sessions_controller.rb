module Api
  module V0
    class SessionsController < ApplicationController
      def index
        if cookies.signed[:user_id] && User.find_by(id: cookies.signed[:user_id])
          render json: { isLoggedIn: true }
        else
          render json: { isLoggedIn: false }
        end
      end

      def create
        user = User.find_by(email: params[:user][:email])
        if user && user.authenticate(params[:user][:password])
          cookies.signed[:user_id] = { value: user.id, same_site: "Strict", expires: 1.hour.from_now }
          render json: { message: "authenticated" }
        else
          render json: { message: "パスワードまたはメールアドレスが正しくありません" }, status: :bad_request
        end
      end

      def logout
        cookies.delete :user_id
      end
    end
  end
end
