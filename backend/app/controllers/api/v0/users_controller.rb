module Api
    module V0
        class UsersController < ApplicationController
            def create
                if !Group.exists?(id: params[:group][:id])
                    render json: {massage: "invalid id"} and return
                end

                @group = Group.find(params[:group][:id])
                if !@group.authenticate(params[:group][:password])
                    render json: {message: "wrong password for the group"} and return
                end

                @user = @group.users.new(user_params)
                if @user.save
                    render json: {message: "user saved"}
                else
                    render json: {message: "user did not saved"}
                end
                puts user_params
            end
            private
            def user_params
                params.require(:user).permit(:name, :email, :password, :password_confirmation)
            end
        end
    end
end



