module FireEngine
  class MembersController < BaseController
    MOCK_NOTES = [
      {
        author: "U01MOCKFD2",
        body: "keep an eye on this one, pattern of jokes that toe the line",
        created_at: 3.days.ago
      }
    ].freeze

    MOCK_CONDUCT_REPORTS_FILED = 2

    def show
      @member = Moderation::MemberProfile.find(params[:id])
      @activity = Analytics::MemberActivity.where(user_id: @member.user_id).order(window_end: :desc).first
      @case_actions = LylaClient.new.case_actions_for_member(@member.user_id)["actions"].map { |a| LylaCaseActionPresenter.build(a) }
      @notes = MOCK_NOTES
      @conduct_reports_filed = MOCK_CONDUCT_REPORTS_FILED
      AccessLog.record!(actor: current_staff, subject_user_id: @member.user_id)
    rescue ActiveRecord::RecordNotFound
      redirect_to fire_engine_root_path, alert: "no member found for that id"
    end
  end
end
