class University < ActiveRecord::Base

	#Validations
	validates :name, presence: true
	#Relations
	has_many :courses
end
