class Base < ApplicationRecord
  belongs_to :user
  
  validates :base_number, presence: true
  validates :base_name, presence: true, length: { maximum: 10 }
  validates :base_category, presence: true, length: { maximum: 50 }
end
