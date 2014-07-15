class University < ActiveRecord::Base

	validates :name, presence: true
end
