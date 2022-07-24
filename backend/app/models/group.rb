class Group < ApplicationRecord
    has_many :users
    has_many :students
    has_many :class_availabilities
    has_many :courses
    validates :name, presence:true
    
    has_secure_password
    CONTAIN_NUM = /.*\d.*/
    CONTAIN_ALPHABET = /.*[A-Za-z].*/
    validates :password, presence: true,
                        length: {minimum:6}
    validates_format_of :password, with: CONTAIN_NUM
    validates_format_of :password, with: CONTAIN_ALPHABET
end
