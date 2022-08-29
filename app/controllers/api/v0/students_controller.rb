module Api
  module V0
    class StudentsController < ApplicationController
      before_action :logged_in?

      def create
        group = User.find_by(id: cookies.signed[:user_id]).group
        student = group.students.new(student_params)
        if student.save
          render json: { message: "ユーザーが作成されました。ID: #{student.id}" }
        else
          render json: { message: student.errors.full_messages }, status: :bad_request
        end
      end

      def index
        group = User.find_by(id: cookies.signed[:user_id]).group
        students_info = []
        group.students.all.each do |student|
          students_info.push({ name: student.name, id: student.id })
        end
        render json: students_info
      end

      def show
        user = User.find_by(id: cookies.signed[:user_id])
        student = Student.find_by(id: params[:id])
        if student && student.group == user.group
          render json: { student: { name: student.name, id: student.id } }, status: :ok
        else
          render json: { message: "エラー" }, status: :bad_request
        end
      end

      private

      def logged_in?
        if !cookies.signed[:user_id]
          render json: { message: "ログインが必要なアクセスです" }, status: :forbidden and return
        end
      end

      def student_params
        params.require(:student).permit(:name)
      end
    end
  end
end
