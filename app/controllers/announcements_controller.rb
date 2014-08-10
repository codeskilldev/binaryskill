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
		if announcement.save
			date = distance_of_time_in_words_to_now announcement.updated_at
			render json: {content: announcement.description, date: date}
		else
			render json: false
		end
	end

	def destroy
		announcement = Announcement.find_by_id(params[:id])
		if announcement.destroy
			render json: true
		else
			render json: false
		end
	end

	def create
		p params
		course = Course.find_by_id(params[:course_id])
		announcement = Announcement.create(description: params[:content],
			owner: current_user)
		course.announcements << announcement
		date = distance_of_time_in_words_to_now announcement.updated_at
		render json: {id: announcement.id, content: announcement.description, date: date}
	end

	private
	def current_user
		if student_signed_in?
			return current_student
		elsif lecturer_signed_in?
			return current_lecturer
		else
			return current_teaching_assistant
		end
	end
end
