module Api
    module V0
        class ClassAvailabilitiesController < ApplicationController
            before_action :is_logged_in

            def search
                puts params
                group = User.find_by(id: session[:user_id]).group
                month_and_year = Time.zone.local(params[:year], params[:month])
                availabilities_for_month = group.class_availabilities.where(from: month_and_year.all_month)
                result = {}
                Range.new(1, month_and_year.end_of_month.day).each do |day|
                    result[day] = []
                end
                availabilities_for_month.each do |av|
                    if av.student
                        result[av.from.day].push({from: {hour: av.from.hour, min: av.from.min}, to: {hour: av.to.hour, min: av.to.min}, reservedBy: av.student.id})
                    else
                        result[av.from.day].push({from: {hour: av.from.hour, min: av.from.min}, to: {hour: av.to.hour, min: av.to.min}, reservedBy: av.student})
                    end
                end
                render json: result and return


                result = []
                availabilities_for_month.each do |av| 
                    if av.student
                        result.push({from: {day: av.from.day, hour: av.from.hour, min: av.from.min}, to: {day: av.to.day, hour: av.to.hour, min: av.to.min}, reservedBy: av.student.id})
                    else
                        result.push({from: {day: av.from.day, hour: av.from.hour, min: av.from.min}, to: {day: av.to.day, hour: av.to.hour, min: av.to.min}, reservedBy: av.student})
                    end
                end
                render json: result

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