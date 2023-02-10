class Base < ApplicationRecord
  validates :base_number, presence: true
  validates :base_name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :attendance_type, presence: true

end