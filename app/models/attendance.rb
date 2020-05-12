class Attendance < ApplicationRecord
  belongs_to :user
  
  enum mark_by_instructor: { "申請中" => 1, "承認" => 2, "否認" => 3 }, _prefix: true      #overtime_mark残業承認
  enum mark_approval: { "申請中" => 1, "承認" => 2, "否認" => 3 }, _prefix: true           #confirmation_mark勤怠変更承認
  enum mark_by_finish: { "申請中" => 1, "承認" => 2, "否認" => 3 }, _prefix: true          #finish_mark最終承認
  
  validates :worked_on, presence: true 
  validates :note, length: { maximum: 50 }
  # チェックチェックボックスがオンか確認
  # validates :change_at, acceptance: true
  
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
    unless Date.current == worked_on
      errors.add(:finished_at, "が必要です") if finished_at.blank? && started_at.present?
    end
  end

  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
  
  # 残業申請にて終了予定時間が指定勤務終了時間より早いのは無効
  validate :overtime_at_than_designated_work_end_time_fast_if_invalid
    
  def overtime_at_than_designated_work_end_time_fast_if_invalid
    if user.designated_work_end_time.present? && overtime_at.present? && next_day == false
      errors.add(:overtime_at, "が不適切な時間です") if user.designated_work_end_time > overtime_at
    end
  end
  
  # 残業申請にて終了予定時間が退社時間より早いのは無効
  validate :overtime_at_than_finished_at_fast_if_invalid
  
  def overtime_at_than_finished_at_fast_if_invalid
    if overtime_at.present? && finished_at.present? && next_day == false
      errors.add(:overtime_at, "が不適切な時間です") if finished_at > overtime_at
    end
  end
  
  # 残業申請にて終了予定時間が存在しない場合は無効
  validate :overtime_at_is_invalid_without_a_overtime_mark
    
  def overtime_at_is_invalid_without_a_overtime_mark
    errors.add(:overtime_at, "が必要です") if overtime_at.blank? && overtime_mark.present?
  end
  
   # 残業承認にて変更チェックがない場合は無効
   validate :change_at_is_invalid_without_mark_by_instructor
  
   def change_at_is_invalid_without_mark_by_instructor 
     errors.add(:overtime_at, "が必要です") if mark_by_instructor.present? && change_at == false
   end
  
  # 勤怠変更にて支持者確認がない場合は無効（出退勤有り）
  validate :confirmation_mark_is_invalid_without_started_at_and_finished_at_present
  
  def confirmation_mark_is_invalid_without_started_at_and_finished_at_present
    if confirmation_mark.blank? 
      errors.add(:mark_approval, "が必要です") if started_at.present? && finished_at.present?
    end
  end
  # 勤怠変更にて支持者確認がない場合は無効（出退勤無し）
  validate :confirmation_mark_or_note_is_invalid_without_started_at_and_finished_at_blank
  
  def confirmation_mark_or_note_is_invalid_without_started_at_and_finished_at_blank
    if confirmation_mark.present? || note.present?
      errors.add(:mark_approval, "が必要です") if started_at.blank? && finished_at.blank?
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

  