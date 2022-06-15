module Api
    module V0
        class UsersController < ApplicationController
            def create
                puts :params
                if !Group.exists?(id: params[:group][:id])
                    render json: {massage: "invalid id"} and return
                end

                @group = Group.find(params[:group][:id])
                if @group.authenticate(params[:group][:password])
                    render json: {message: "you're in"}
                else
                    render json: {message: "wrong password"}
                end
            end
        end
    end
end



