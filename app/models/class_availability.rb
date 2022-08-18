class ClassAvailability < ApplicationRecord
  belongs_to :group
  belongs_to :student, optional: true
  validates :to, presence: true
  validates :from, presence: true
end
