class AnnouncementsController < ApplicationController
	include ActionView::Helpers::DateHelper

	def index
		@course = Course.find_by_id(params[:course_id])
		@announcements = @course.announcements
	end

	def edit
		announcement = Announcement.find_by_id(params[:id])
		date = distance_of_time_in_words_to_now announcement.updated_at
		render json: {content: announcement.description, date: date}
	end

	def update
		announcement = Announcement.find_by_id(params[:id])
		announcement.description = params[:content]
		announcement.save!
		render json: {content: announcement.description, date: date}
	end

	def destroy
		announcement = Announcement.find_by_id(params[:id])
		announcement.destroy!
	end
end
