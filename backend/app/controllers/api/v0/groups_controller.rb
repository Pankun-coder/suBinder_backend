module Api
    module V0
        class GroupsController < ApplicationController
            def index
                group_ids = []
                Group.all.each {|group|
                    group_ids.push(group.id)
                }
                render json: {group_ids: group_ids}
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