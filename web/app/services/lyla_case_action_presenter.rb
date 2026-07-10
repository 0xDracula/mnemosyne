class LylaCaseActionPresenter
  def self.build(a)
    data = a["data"] || {}

    {
      case_number: a["caseNumber"],
      action_type: a["actionType"],
      target_user_id: a["targetUserId"],
      performed_by: (a["performedBy"] || []).join(", "),
      what_they_did: data["whatTheyDid"],
      ban_until: data["banUntil"].presence && Date.parse(data["banUntil"]),
      performed_at: Time.at(a["performedAt"] / 1000.0),
      thread_url: data["permalink"]
    }
  end
end
