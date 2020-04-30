class Base < ApplicationRecord
  VALID_NUMBER_REGEX = /\A[0-9]+\z/
  validates :base_number, presence: true, uniqueness: true, numericality: {only_integer: true }
  validates :base_name, presence: true, length: { maximum: 10 }
  validates :base_category, presence: true, length: { maximum: 10 }
end
