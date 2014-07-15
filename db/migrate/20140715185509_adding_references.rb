class AddingReferences < ActiveRecord::Migration
  def change
  	add_column :courses, :university_id, :integer
  end
end
