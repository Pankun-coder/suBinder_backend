
module Api
  module V0
    class ProgressesController < ApplicationController
      before_action :is_logged_in
      def bulk_update
        params[:progresses].each do |progress_data|
          progress = Progress.find_by(id: progress_data.id)
          if progress.student.group != User.find_by(id: session[:userid]).group
            render json: { message: "権限のない進捗情報です" }, status: :forbidden and return
          end
          if progress_data.is_completed.class != "boolean"
            render json: { message: "進捗情報が不正です" }, status: :bad_request and return
          end
        end
        params[:progresses].each do |progress_data|
          progress = Progress.find_by(id: progress_data.id)
          progress.is_completed = progress_data.is_completed
          if !progress.save
            render json: { message: "進捗情報が不正です" }, status: :bad_request and return
          end
          render json: { message: "正常に保存されました" }, status: :ok and return
        end
      end
      def search
        if !params[:student_id]
          render json: { message: "生徒IDは必須です" }, status: :bad_request and return 
        end
        student = Student.find_by(id: params[:student_id])
        if !student || student.group != User.find(session[:user_id]).group
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
      def is_logged_in
        if !session[:user_id]
            render json: { message: "ログインが必要なアクセスです"}, status: :forbidden and return
        end
      end
    end
  end
end