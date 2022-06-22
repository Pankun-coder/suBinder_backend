module Api
    module V0
        class StudentsController < ApplicationController
            def search
                if !session[:user_id]
                    render json: { message: "you are not logged in"} and return
                end

                nums_only = /\A\d*\z/
                start_with_query = /^#{params[:query]}/

                group = User.find_by(id: session[:user_id]).group

                if params[:query].match(nums_only)
                    possible_students = group.students.where("id LIKE ?", "#{params[:query]}%").limit(5)
                else
                    possible_students = group.students.where("name LIKE ?", "#{params[:query]}%").limit(5)
                end

                suggestions = {}
                index = 0
                possible_students.each do |student|
                    suggestions[index] = { name: student.name, id: student.id}
                    index += 1;
                end
                
                render json: { "suggestions": suggestions }
            end

        end
    end
end
