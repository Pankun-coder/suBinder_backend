class AddIndexToStepStepOrder < ActiveRecord::Migration[7.0]
  def change
    add_index :steps, [:step_order, :course_id], unique: true
  end
end
