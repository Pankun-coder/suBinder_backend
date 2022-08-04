module Api
  module V0
    class ProgressesController < ApplicationController
      before_action :logged_in?
      def bulk_update
        params[:progresses].each do |progress_data|
          progress = Progress.find_by(id: progress_data[:id])
          if progress.student.group != User.find_by(id: cookies.signed[:user_id]).group
            render json: { message: "権限のない進捗情報です" }, status: :forbidden and return
          end
        end
        params[:progresses].each do |progress_data|
          progress = Progress.find_by(id: progress_data[:id])
          progress[:is_completed] = progress_data[:is_completed]
          if !progress.save
            render json: { message: progress.errors.full_messages }, status: :bad_request and return
          end
        end
        render json: { message: "正常に保存されました" }, status: :ok and return
      end

      def bulk_create
        group = User.find_by(id: cookies.signed[:user_id]).group
        student = Student.find_by(id: params[:student_id])
        if !student || student.group != group
          render json: { message: "生徒IDが無効です" }, status: :not_found and return
        end

        course = Course.find_by(id: params[:course_id])
        if !course || course.group != group
          render json: { message: "コースIDが無効です" }, status: :not_found and return
        end

        progresses = []
        course.steps.each do |step|
          progresses.push(Progress.new(student: student, step: step, is_completed: false))
          if progresses[-1].save
            next
          else
            progresses.each do |progress|
              progress.destroy
            end
            render json: { message: progresses[-1].errors.full_messages }, status: :bad_request and return nil
          end
        end
        render json: { message: "コースが正常に登録されました" }, status: :ok and return
      end

      def search
        if !params[:student_id]
          render json: { message: "生徒IDは必須です" }, status: :bad_request and return
        end

        student = Student.find_by(id: params[:student_id])
        if !student || student.group != User.find(cookies.signed[:user_id]).group
          render json: { message: "生徒情報が無効です" }, status: :not_found and return
        end

        progresses_JSON = {}
        progresses = student.progresses.all
        progresses.each do |progress|
          if !progresses_JSON[progress.step.course.id]
            progresses_JSON[progress.step.course.id] = {
              name: progress.step.course.name,
              steps: Array.new(progress.step.course.steps.all.length, nil)
            }
          end
          progresses_JSON[progress.step.course.id][:steps][progress.step.step_order] = {
            name: progress.step.name,
            isCompleted: progress.is_completed,
            id: progress.id
          }
        end
        render json: { progresses: progresses_JSON }, status: :ok and return
      end

      private

      def logged_in?
        if !cookies.signed[:user_id]
          render json: { message: "ログインが必要なアクセスです" }, status: :forbidden and return
        end
      end
    end
  end
end
