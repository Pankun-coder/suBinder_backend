class Student < ApplicationRecord
  belongs_to :group
  has_many :progresses, dependent: :destroy
  validates :name, presence:true
end