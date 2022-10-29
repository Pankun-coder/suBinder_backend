module Api
  module V1
    class ClassAvailabilitiesController < ApplicationController
      def search
        group = User.find_by(id: cookies.signed[:user_id]).group
        month_and_year = Time.zone.local(params[:year], params[:month])
        availabilities_for_month = group.class_availabilities.where(from: month_and_year.all_month)
        result = []
        availabilities_for_month.each do |av|
          if av.student
            result.push({ from: av.from, to: av.to, reservedBy: { id: av.student.id, name: av.student.name }, id: av.id })
          else
            result.push({ from: av.from, to: av.to, reservedBy: { id: nil, name: nil }, id: av.id })
          end
        end
        render json: result and return
      end

      def create
        group = User.find_by(id: cookies.signed[:user_id]).group
        render json: { message: "日付が不正です" }, status: :bad_request and return if !valid_date?(params[:from]) || !valid_date?(params[:to])
        render json: { message: "時刻が不正です" }, status: :bad_request and return if !valid_time?(params[:time][:from]) || !valid_time?(params[:time][:to])
        render json: { message: "枠数の情報が不正です" }, status: :bad_request and return unless int?(params[:how_many])
        render json: { message: "100人分以上の予約は一度に作れません" }, status: :bad_request and return if params[:how_many] > 100

        day = Time.zone.local(params[:from][:year], params[:from][:month], params[:from][:day])

        last_day = Time.zone.local(params[:to][:year], params[:to][:month], params[:to][:day]).tomorrow

        while day < last_day
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

      def update
        group = User.find_by(id: cookies.signed[:user_id]).group
        availability = ClassAvailability.find_by(id: params[:id])
        render json: { message: "予約情報が不正です" }, status: :not_found and return unless availability
        render json: { message: "権限のない予約です" }, status: :forbidden and return if availability.group != group

        case params[:cancel]
        when "false"
          render json: { message: "すでに予約されています" }, status: :bad_request and return unless availability.student.nil?

          student = Student.find_by(id: params[:student_id])
          availability.student = student
          render json: { message: "すでに同じ時間に予約が入っています" }, status: :bad_request and return unless ClassAvailability.where(from: availability.from, to: availability.to, student:).empty?

          render json: { message: "予約しました" } and return if availability.save

          render json: { message: availability.errors.full_messages }, status: :internal_server_error and return
        when "true"
          availability.student = nil
          render json: { message: "予約をキャンセルしました" } and return if availability.save

          render json: { message: availability.errors.full_messages }, status: :bad_request and return
        end
      end

      private

      def logged_in?
        render json: { message: "ログインが必要なリクエストです" }, status: :forbidden and return unless cookies.signed[:user_id]
      end

      def valid_date?(date_in_json)
        return false unless int?(date_in_json[:year]) && int?(date_in_json[:month]) && int?(date_in_json[:day])
        return false if date_in_json[:year] < 2000 || date_in_json[:year] > 3000
        return false if date_in_json[:month] < 1 || date_in_json[:month] > 12
        return false if date_in_json[:day] < 1 || date_in_json[:day] > Time.zone.local(date_in_json[:year], date_in_json[:month]).end_of_month.day

        true
      end

      def valid_time?(time_in_json)
        return false unless int?(time_in_json[:hour]) && int?(time_in_json[:min])
        return false if time_in_json[:hour].negative? || time_in_json[:hour] > 23
        return false if time_in_json[:min].negative? || time_in_json[:min] > 59

        true
      end

      def int?(object)
        object == instance_of?(Integer)
      end

      def set_time(date, time)
        time_in_str = "#{time[:hour]}:#{time[:min]}:00"
        Time.zone.parse(date.to_s.sub(/\d\d:\d\d:\d\d/, time_in_str))
      end
    end
  end
end
