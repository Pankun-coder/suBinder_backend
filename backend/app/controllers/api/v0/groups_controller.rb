module Api
    module V0
        class GroupsController < ApplicationController
            def index
                if session[:user_id]
                    user = User.find_by(id: session[:user_id])
                    render json: { message: "you're logged in", group: user.group.name}
                else
                    render json: { errors: "era-", "status": 404}
                end
            end
            def create
                @group = Group.new(group_params)
                if @group.save
                    render json: {message: "success"}
                else
                    render json: {message: "fail"}
                end 
            end
            def show
                if !Group.exists?(id: params[:id])
                    render json: {massage: "invalid id"} and return
                end
                @group = Group.find(params[:id])
                render json: {group: {name: @group.name}, message:"group loaded"}
            end
                     
            private
                def group_params
                    params.require(:group).permit(:name, :password, :password_confirmation)
                end
        end 
    end
end