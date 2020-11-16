class Wod < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  validates_presence_of :content
  validate :must_be_same_date_as_specified_date, if: :specified_date

  private

  def must_be_same_date_as_specified_date
    if date != specified_date
      errors[:base] << "指定したWodの日付と異なっています。"
    end
  end
end
