module Api
  module V0
    class UsersController < ApplicationController
      def create
        if !Group.exists?(id: params[:group][:id])
          render json: { massage: "グループのIDが無効です" }, status: :not_found and return
        end

        group = Group.find(params[:group][:id])
        if !group.authenticate(params[:group][:password])
          render json: { message: "グループのパスワードが違います" }, status: :unauthorized and return
        end

        user = group.users.new(user_params)
        if user.save
          render json: { message: "user saved" }
        else
          render json: { message: user.errors.full_messages }, status: :bad_request
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
