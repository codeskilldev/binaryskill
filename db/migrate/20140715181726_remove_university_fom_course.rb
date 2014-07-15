class RemoveUniversityFomCourse < ActiveRecord::Migration
  def change
  	remove_column :courses, :university
  end
end
