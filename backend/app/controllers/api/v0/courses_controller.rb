
module Api
  module V0
    class CoursesController < ApplicationController
      before_action :is_logged_in
      def index
        group = User.find_by(id: session[:user_id]).group
        courseInfo = []
        group.courses.each do |course|
          courseInfo.push({id: course[:id], name: course[:name]})
        end
      render json: { courses: courseInfo }, status: :ok and return
      end
      def create
        group = User.find(session[:user_id]).group
        course = group.courses.new(name: params[:course][:name])
        puts params[:course][:name]
        if !course.save
          render json: { message: "教材の登録に失敗しました" }, status: :bad_request and return
        end
        puts params[:steps].class
        params[:steps].each do |required_step|
          step = course.steps.new(name: required_step[:name])
          if step.save
            next
          else
            course.steps.each do |step|
              step.destroy
            end
            course.destroy
            render json: { message: "ステップの登録に失敗しました" }, status: :bad_request and return
          end
        end
        render json: { message: "教材が正常に登録されました" }, status: :ok and return
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