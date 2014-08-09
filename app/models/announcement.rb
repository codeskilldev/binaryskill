class Announcement < ActiveRecord::Base

	default_scope { order('updated_at DESC') }
	#Relations
	belongs_to :owner, polymorphic: true
	belongs_to :course
end
