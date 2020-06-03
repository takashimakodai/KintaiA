class Attendance < ApplicationRecord
  belongs_to :user
  
  enum mark_by_instructor: { "なし" => 0, "申請中" => 1, "承認" => 2, "否認" => 3 }, _prefix: true      #上長overtime_mark残業承認
  enum mark_approval: { "なし" => 0, "申請中" => 1, "承認" => 2, "否認" => 3 }, _prefix: true           #上長confirmation_mark勤怠変更承認
  enum mark_by_finish: { "なし" => 0, "申請中" => 1, "承認" => 2, "否認" => 3 }, _prefix: true          #上長finish_mark最終承認
  
  validates :worked_on, presence: true 
  validates :note, length: { maximum: 50 }
  
  # 出勤時間が存在しない場合、退勤時間は無効(NO.7)
  validate :finished_at_is_invalid_without_a_started_at
  # 退勤時間が存在しない場合、出勤時間は無効
  validate :started_at_is_invalid_without_a_finished_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効(NO.8)
  validate :started_at_than_finished_at_fast_if_invalid
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present? 
  end

  def started_at_is_invalid_without_a_finished_at
    errors.add(:finished_at, "が必要です") if finished_at.blank? && started_at.present?
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present? && next_day == false
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
  
  # 勤怠編集で出勤、退勤が存在する場合、備考が必要。
  #validate :note_is_without_started_at_and_finished_at
  def note_is_without_started_at_and_finished_at
    if started_at.present? && finished_at.present?
      errors.add(:note, "が必要です") if note.blank?
    end
  end
      
  
  # 勤怠編集で出勤、退勤ともに存在し上長マークがない場合
  #validate :confirmation_mark_finished_at_without_started_at_both
  def confirmation_mark_finished_at_without_started_at_both 
    if started_at.present? && finished_at.present?
      errors.add(:confirmation_mark, "が必要です") if confirmation_mark.blank?
    end
  end
  
  # 勤怠編集で上長マークがが存在する場合、出勤と退勤と備考が必要
  validate :confirmation_mark_is_without_a_started_at_a_finished_at_a_note
  def confirmation_mark_is_without_a_started_at_a_finished_at_a_note 
    if confirmation_mark.present? && started_at.present? && finished_at.present?
      errors.add(:confirmation_mark, "3つ必要です") if note.blank?
    end
  end
  
  # 勤怠編集で備考が存在する中、出勤と退勤がない場合（上長マーク有）
  #validate :note_is_without_a_started_at_a_finished_at
  def note_is_without_a_started_at_a_finished_at 
    if note.present?
      errors.add(:confirmation_mark, "3つ必要です") if started_at.blank? && finished_at.blank? && confirmation_mark.present?
    end
  end
  
  # 勤怠編集で変更マークが存在する中、出勤と退勤がない場合（上長マーク無）
  #validate :next_day_is_without_confirmation_mark_a_started_at_a_finished_at
  def next_day_is_without_confirmation_mark_a_started_at_a_finished_at 
    if next_day == true  
      errors.add(:confirmation_mark, "3つ必要です") if started_at.blank? && finished_at.blank? && confirmation_mark.blank?
    end
  end
  
  # 残業申請で指定勤務時間よりも早い残業時間は無効(チェック無)
  validate :overtime_at_is_invalid_without_fast_a_designated_work_end_time
  def overtime_at_is_invalid_without_fast_a_designated_work_end_time
    if overtime_at.present? && overtime_next_day.blank?
      errors.add(:overtime_at, "が必要です") if user.designated_work_end_time.strftime("%H:%M").to_i > overtime_at.strftime("%H:%M").to_i
    end
  end
  
  # 残業申請では、退社時間があれば終了予定時間は無効です。
  validate :overtime_at_is_invalid_without_a_overtime_mark
  def overtime_at_is_invalid_without_a_overtime_mark
    errors.add(:overtime_at, "が必要です") if overtime_mark.present? && overtime_at.blank?
  end
  
  # 残業申請では、上長マークと終了予定時間が必要です。
  validate :overtime_at_is_invalid_without_a_overtime_mark
  def overtime_at_is_invalid_without_a_overtime_mark 
    errors.add(:overtime_at, "が必要です") if overtime_mark.present? && overtime_at.blank?
  end
  
  # 残業承認にて変更チェックがない場合は無効
  validate :change_at_is_invalid_without_mark_by_instructor
  def change_at_is_invalid_without_mark_by_instructor 
    errors.add(:overtime_at, "が必要です") if mark_by_instructor.present? && change_at == false
  end
  
  # 勤怠変更にて支持者確認がない場合は無効（出退勤有り）
  #validate :confirmation_mark_is_invalid_without_started_at_and_finished_at_present
  def confirmation_mark_is_invalid_without_started_at_and_finished_at_present
    if confirmation_mark.blank? 
      errors.add(:mark_approval, "が必要です") if started_at.present? && finished_at.present?
    end
  end
  
  # 勤怠変更にて支持者確認がない場合は備考及び翌日は無効（出退勤無し）
  #validate :confirmation_mark_or_note_or_next_day_is_invalid_without_started_at_and_finished_at_blank
  def confirmation_mark_or_note_or_next_day_is_invalid_without_started_at_and_finished_at_blank 
    if confirmation_mark.present?
      errors.add(:confirmation_mark, "が必要です") if started_at.blank? && finished_at.blank?
    end
  end

  # 最終承認にて支持者確認が存在し、変更マークがない場合は無効
  validate :change_at_is_invalid_without_mark_by_finish_present
  def change_at_is_invalid_without_mark_by_finish_present
    if mark_by_finish.present?
      errors.add(:change_at, "が必要です") if change_at == false
    end
  end

end

  