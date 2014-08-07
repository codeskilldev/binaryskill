class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.text :description

      t.references :course
      t.references :owner, polymorphic: true
      t.timestamps
    end
  end
end
