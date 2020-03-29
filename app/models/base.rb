class Base < ApplicationRecord
  belongs_to :user
  
  validates :base_number, presence: true
  validates :base_name, length: { maximum: 50 }
  validates :base_category, length: { maximum: 50 }
  
end
