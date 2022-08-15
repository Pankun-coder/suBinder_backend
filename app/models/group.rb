class Group < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :students, dependent: :destroy
  has_many :class_availabilities, dependent: :destroy
  has_many :courses, dependent: :destroy
  validates :name, presence: true

  has_secure_password
  CONTAIN_NUM = /.*\d.*/
  CONTAIN_ALPHABET = /.*[A-Za-z].*/
  validates :password, presence: true,
                       length: { minimum: 6 }
  validates :password, format: { with: CONTAIN_NUM }
  validates :password, format: { with: CONTAIN_ALPHABET }
end
