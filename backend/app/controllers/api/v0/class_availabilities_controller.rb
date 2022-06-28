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
                student = Student.find_by(id: params[:user_id])
                if availability.student == nil
                    if availability.group == group
                        availability.student = student
                    else
                        render json: {message: "管轄外の予約です"} and return
                    end
                else
                    render json: {message: "already reserved"} and return
                end

                if availability.save
                    render json: {message: "reserved"} and return
                else
                    render json: {message: "error"} and return
                end
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