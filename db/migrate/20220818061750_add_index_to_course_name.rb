class AddIndexToCourseName < ActiveRecord::Migration[7.0]
  def change
    add_index :courses, [:group_id, :name], unique: true
  end
end
