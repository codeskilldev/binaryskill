class AnnouncementsController < ApplicationController
	def index
		@course = Course.find_by_id(params[:course_id])
		@announcements = @course.announcements
	end
end
