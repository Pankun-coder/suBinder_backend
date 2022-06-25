module Api
    module V0
        class ClassAvailabilitiesController < ApplicationController
            before_action :is_logged_in

            def search
                puts params
                group = User.find_by(id: session[:user_id]).group
                month_and_year = Time.zone.local(params[:year], params[:month])
                availabilities_for_month = group.class_availabilities.where(from: month_and_year.all_month)
                rearranged_availabilities = []
                availabilities_for_month.each do |av| 
                    rearranged_availabilities.push({from: {day: av.from.day, hour: av.from.hour, min: av.from.min}, to: {day: av.to.day, hour: av.to.hour, min: av.to.min}})
                end
                render json: rearranged_availabilities
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