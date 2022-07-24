class Course < ApplicationRecord
  belongs_to :group
  has_many :steps

  validates :name, presence:true,
                    uniqueness: { scope: :group_id }
end
