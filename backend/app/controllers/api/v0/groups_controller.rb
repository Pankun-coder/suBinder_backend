module Api
    module V0
        class GroupsController < ApplicationController
            def index
            end
            def create
                @group = Group.new(group_params)
                if @group.save
                    render json: {message: "success"}
                else
                    render json: {message: "fail"}
                end 
            end
            private
                def group_params
                    params.require(:group).permit(:name, :password, :password_confirmation)
                end
            end 
    end
end