module Api
    module V0
        class ClassAvailabilitiesController < ApplicationController
            before_action :is_logged_in

            def search
                group = User.find_by(id: session[:user_id]).group
                month_and_year = Time.zone.local(params[:year], params[:month])
                availabilities_for_month = group.class_availabilities.where(from: month_and_year.all_month)
                result = {}
                Range.new(1, month_and_year.end_of_month.day).each do |day|
                    result[day] = []
                end
                availabilities_for_month.each do |av|
                    if av.student
                        result[av.from.day].push({from: {hour: av.from.hour, min: av.from.min}, to: {hour: av.to.hour, min: av.to.min}, reservedBy: {id: av.student.id, name: av.student.name}, id: av.id})
                    else
                        result[av.from.day].push({from: {hour: av.from.hour, min: av.from.min}, to: {hour: av.to.hour, min: av.to.min}, reservedBy: {id: nil, name: nil}, id: av.id})
                    end
                end
                render json: result and return
            end
            
            def update
                group = User.find_by(id: session[:user_id]).group
                availability = ClassAvailability.find_by(id: params[:id])
                if !availability
                    render json: { message: "予約情報が不正です"}, status: :not_found and return
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
                        render json: { message: "すでに同じ時間に予約が入っています"}, status: :bad_request and return
                    end

                    if availability.save
                        render json: { message: "予約しました" } and return
                    else
                        render json: { message: "予約に失敗しました" }, status: :internal_server_error and return
                    end

                elsif params[:cancel] == "true"
                    availability.student = nil
                    if availability.save
                        render json: { message: "予約をキャンセルしました" } and return
                    end
                    render json: { message: "キャンセルに失敗しました"}, status: :bad_request and return
                end
            end
            
            def create
                group = User.find_by(id: session[:user_id]).group
                if !is_valid_date(params[:from]) || !is_valid_date(params[:to])
                    render json: {message: "日付が不正です"}, status: :bad_request and return
                end
                class_starts_at = Time.zone.local(params[:from][:year], params[:from][:month], params[:from][:day], params[:time][:from][:hour], params[:time][:from][:min])
                class_ends_at = Time.zone.local(params[:from][:year], params[:from][:month], params[:from][:day], params[:time][:to][:hour], params[:time][:to][:min])
                lastDay = Time.zone.local(params[:to][:year], params[:to][:month], params[:to][:day]).tomorrow

                while class_starts_at < lastDay
                    if params[:days][class_starts_at.wday]
                        params[:how_many].to_i.times do
                            av = group.class_availabilities.new(from: class_starts_at, to: class_ends_at)
                            av.save
                        end
                    end
                    class_starts_at = class_starts_at.tomorrow
                    class_ends_at = class_ends_at.tomorrow
                end
                render json: {message: "正常に保存されました"}, status: :ok and return
            end



            private
                def is_logged_in
                    if !session[:user_id]
                        render json: { message: "ログインが必要なリクエストです" }, status: :forbidden and return
                    end
                end

                def is_valid_date(date_in_JSON)
                    nums_only = /\A\d*\z/
                    if !(date_in_JSON[:year].match(nums_only) && date_in_JSON[:month].match(nums_only) && date_in_JSON[:day].match(nums_only))
                        return false
                    end
                    if date_in_JSON[:year].to_i < 2000 || date_in_JSON[:year].to_i > 3000
                        return false
                    end
                    if date_in_JSON[:month].to_i < 1 || date_in_JSON[:month].to_i > 12
                        return false
                    end
                    if date_in_JSON[:day].to_i < 1 || date_in_JSON[:day].to_i > Time.zone.local(date_in_JSON[:year], date_in_JSON[:month]).end_of_month.day
                        return false
                    end
                    return true
                end
                    

        end
    end
end