class Announcement < ActiveRecord::Base

	#Relations
	belongs_to :owner, polymorphic: true
	belongs_to :course
end
