class Wod < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  validates_presence_of :strength, if: :strength_record
  validates_presence_of :conditioning, if: :conditioning_reocrd
  validates_presence_of :wod, if: :wod_record
  validate :must_have_at_least_one_workout

  def must_have_at_least_one_workout
    if strength.blank? && conditioning.blank? && wod.blank?
      errors[:base] << "ワークアウトが入力されていません。"
    end
  end
end
