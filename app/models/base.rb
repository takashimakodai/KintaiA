class Base < ApplicationRecord
  validates :base_number, presence: true, uniqueness: true
  validates :base_name, presence: true, length: { maximum: 10 }
  validates :base_category, presence: true, length: { maximum: 10 }
end
