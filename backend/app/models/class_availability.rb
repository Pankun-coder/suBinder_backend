class ClassAvailability < ApplicationRecord
    belongs_to :group
    belongs_to :student, optional: true
end
