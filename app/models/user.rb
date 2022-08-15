class User < ApplicationRecord
  belongs_to :group

  validates :name, presence: true

  VALID_EMAIL = /\A^[a-zA-Z0-9_+-]+(.[a-zA-Z0-9_+-]+)*@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.)+[a-zA-Z]{2,}\z/
  validates :email, presence: true,
                    format: { with: VALID_EMAIL },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  CONTAIN_NUM = /.*\d.*/
  CONTAIN_ALPHABET = /.*[A-Za-z].*/
  validates :password, presence: true,
                       length: { minimum: 6 }
  validates :password, format: { with: CONTAIN_NUM }
  validates :password, format: { with: CONTAIN_ALPHABET }
end
