class AddIndexToProgressesStep < ActiveRecord::Migration[7.0]
  def change
    add_index :progresses, [:step_id, :student_id], unique: true
  end
end
