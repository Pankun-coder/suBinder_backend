module Api
    module V0
        class StudentsController < ApplicationController
            before_action :is_logged_in

            def search
                nums_only = /\A\d*\z/
                start_with_query = /^#{params[:query]}/

                group = User.find_by(id: session[:user_id]).group

                if params[:query].match(nums_only)
                    possible_students = group.students.where("id LIKE ?", "#{params[:query]}%").limit(5)
                else
                    possible_students = group.students.where("name LIKE ?", "#{params[:query]}%").limit(5)
                end

                suggestions = []
                possible_students.each do |student|
                    suggestions.push({ name: student.name, id: student.id})
                end
                
                render json: suggestions
            end


            def show
                group = User.find_by(id: session[:user_id]).group
            end


            private
                def is_logged_in
                    if !session[:user_id]
                        render json: { message: "you are not logged in"} and return
                    end
                end
        end
    end
end
