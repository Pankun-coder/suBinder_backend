class Step < ApplicationRecord
  belongs_to :course

  validates :name, presence: true
  validates :step_order, uniqueness: { scope: :course_id }

  before_create :autofill_step_order

  def autofill_step_order
    if self.step_order == nil
      self.step_order = 0
      steps = self.course.steps.all
      steps.each do |step|
        if step.step_order >= self.step_order
          self.step_order = step.step_order + 1
        end
      end
    end
  end

end
