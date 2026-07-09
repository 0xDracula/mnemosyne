class AccessLog < ApplicationRecord
  self.table_name = "access_log"

  def self.record!(actor:, subject_user_id:, field_class: "profile")
    create!(
      actor_id: actor.user_id,
      subject_user_id: subject_user_id,
      field_class: field_class,
      looked_at: Time.current
    )
  end
end
