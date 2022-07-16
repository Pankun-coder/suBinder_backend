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

            def create
                group = User.find_by(id: session[:user_id]).group
                student = group.students.new(student_params)
                if student.save
                    render json: { message: "ユーザーが作成されました。ID: #{student.id}"}
                else
                    render json: { message: "ユーザーの作成に失敗しました。"}, status: :bad_request
                end
            end
            
            def index
                group = User.find_by(id: session[:user_id]).group
                students_info = []
                group.students.all.each do |student|
                    students_info.push({ name: student.name, id: student.id})
                end
                render json: students_info
            end

            def show
                user = User.find_by(id: session[:user_id])
                student = Student.find_by(id: params[:id])
                if student && student.group == user.group
                    render json: { student: { name: student.name, id: student.id }}, status: 200
                else
                    render json: {message: "エラー"}, status: 400
                end
            end

            private
                def is_logged_in
                    if !session[:user_id]
                        render json: { message: "ログインが必要なアクセスです"}, status: 403 and return
                    end
                end

                def student_params
                    params.require(:student).permit(:name)
                end
        end
    end
end
