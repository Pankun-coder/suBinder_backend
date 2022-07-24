class Student < ApplicationRecord
    belongs_to :group
    has_many :progresses
    validates :name, presence:true
end