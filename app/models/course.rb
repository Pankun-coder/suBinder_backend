class Course < ApplicationRecord
  belongs_to :group
  has_many :steps, dependent: :destroy

  validates :name, presence: true
end
