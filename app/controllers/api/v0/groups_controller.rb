module Api
  module V0
    class GroupsController < ApplicationController
      def index
        if cookies.signed[:user_id]
          user = User.find_by(id: cookies.signed[:user_id])
          render json: { message: "you're logged in", group: user.group.name }
        else
          render json: { message: "エラー" }, status: :bad_request
        end
      end

      def create
        group = Group.new(group_params)
        if group.save
          render json: { message: "success", group_id: group.id }
        else
          render json: { message: group.errors.full_messages }, status: :bad_request
        end
      end

      def show
        if !Group.exists?(id: params[:id])
          render json: { massage: "invalid id" }, status: :not_found and return
        end

        group = Group.find(params[:id])
        render json: { group: { name: group.name }, message: "group loaded" }
      end

      private

      def group_params
        params.require(:group).permit(:name, :password, :password_confirmation)
      end
    end
  end
end
