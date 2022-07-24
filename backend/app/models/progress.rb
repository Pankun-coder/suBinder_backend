class Progress < ApplicationRecord
  belongs_to :student
  belongs_to :step

  validates :is_completed, inclusion: [true, false]
end
