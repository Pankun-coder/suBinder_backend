module Api
    module V0
        class SessionsController < ApplicationController

            def create
                puts params
                user = User.find_by(email: params[:user][:email])
                puts user
                puts "aaa"
                if user && user.authenticate(params[:user][:password])
                    puts "authenticated"
                    session[:user_id] = user.id
                    render json: {message: "authenticated"}
                else
                    puts "something went wrong"
                    render json: {message: "not authenticated"}
                end
            

            end
        end
    end
end
