module Api
  module V0
    class ClassAvailabilitiesController < ApplicationController
      before_action :logged_in?

      def search
        group = User.find_by(id: cookies.signed[:user_id]).group
        month_and_year = Time.zone.local(params[:year], params[:month])
        availabilities_for_month = group.class_availabilities.where(from: month_and_year.all_month)
        result = {}
        Range.new(1, month_and_year.end_of_month.day).each do |day|
          result[day] = []
        end
        availabilities_for_month.each do |av|
          if av.student
            result[av.from.day].push({ from: { hour: av.from.hour, min: av.from.min }, to: { hour: av.to.hour, min: av.to.min }, reservedBy: { id: av.student.id, name: av.student.name }, id: av.id })
          else
            result[av.from.day].push({ from: { hour: av.from.hour, min: av.from.min }, to: { hour: av.to.hour, min: av.to.min }, reservedBy: { id: nil, name: nil }, id: av.id })
          end
        end
        render json: result and return
      end

      def update
        group = User.find_by(id: cookies.signed[:user_id]).group
        availability = ClassAvailability.find_by(id: params[:id])
        if !availability
          render json: { message: "予約情報が不正です" }, status: :not_found and return
        end
        if availability.group != group
          render json: { message: "権限のない予約です" }, status: :forbidden and return
        end

        if params[:cancel] == "false"
          if availability.student != nil
            render json: { message: "すでに予約されています" }, status: :bad_request and return
          end

          student = Student.find_by(id: params[:student_id])
          availability.student = student
          if ClassAvailability.where(from: availability.from, to: availability.to, student: student).length != 0
            render json: { message: "すでに同じ時間に予約が入っています" }, status: :bad_request and return
          end

          if availability.save
            render json: { message: "予約しました" } and return
          else
            render json: { message: availability.errors.full_messages }, status: :internal_server_error and return
          end

        elsif params[:cancel] == "true"
          availability.student = nil
          if availability.save
            render json: { message: "予約をキャンセルしました" } and return
          end

          render json: { message: availability.errors.full_messages }, status: :bad_request and return
        end
      end

      def create
        group = User.find_by(id: cookies.signed[:user_id]).group
        if !valid_date?(params[:from]) || !valid_date?(params[:to])
          render json: { message: "日付が不正です" }, status: :bad_request and return
        end
        if !valid_time?(params[:time][:from]) || !valid_time?(params[:time][:to])
          render json: { message: "時刻が不正です" }, status: :bad_request and return
        end
        if !int?(params[:how_many])
          render json: { message: "枠数の情報が不正です" }, status: :bad_request and return
        end
        if params[:how_many] > 100
          render json: { message: "100人分以上の予約は一度に作れません" }, status: :bad_request and return
        end

        day = Time.zone.local(params[:from][:year], params[:from][:month], params[:from][:day])

        lastDay = Time.zone.local(params[:to][:year], params[:to][:month], params[:to][:day]).tomorrow

        while day < lastDay
          if params[:days][day.wday]
            params[:how_many].times do
              av = group.class_availabilities.new(from: set_time(day, params[:time][:from]), to: set_time(day, params[:time][:to]))
              av.save
            end
          end
          day = day.tomorrow
        end
        render json: { message: "正常に保存されました" }, status: :ok and return
      end

      private

      def logged_in?
        if !cookies.signed[:user_id]
          render json: { message: "ログインが必要なリクエストです" }, status: :forbidden and return
        end
      end

      def valid_date?(date_in_json)
        if !(int?(date_in_json[:year]) && int?(date_in_json[:month]) && int?(date_in_json[:day]))
          return false
        end
        if date_in_json[:year] < 2000 || date_in_json[:year] > 3000
          return false
        end
        if date_in_json[:month] < 1 || date_in_json[:month] > 12
          return false
        end
        if date_in_json[:day] < 1 || date_in_json[:day] > Time.zone.local(date_in_json[:year], date_in_json[:month]).end_of_month.day
          return false
        end

        return true
      end

      def valid_time?(time_in_json)
        if !(int?(time_in_json[:hour]) && int?(time_in_json[:min]))
          return false
        end
        if time_in_json[:hour] < 0 || time_in_json[:hour] > 23
          return false
        end
        if time_in_json[:min] < 0 || time_in_json[:min] > 59
          return false
        end

        return true
      end

      def int?(object)
        if object.class == Integer
          return true
        else
          return false
        end
      end

      def set_time(date, time)
        time_in_str = "#{time[:hour]}:#{time[:min]}:00"
        return Time.zone.parse(date.to_s.sub(/\d\d:\d\d:\d\d/, time_in_str))
      end
    end
  end
end
