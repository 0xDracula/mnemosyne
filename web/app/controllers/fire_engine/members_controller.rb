module FireEngine
  class MembersController < BaseController
    def show
      @member = Moderation::MemberProfile.find(params[:id])
      @activity = Analytics::MemberActivity.where(user_id: @member.user_id).order(window_end: :desc).first
      AccessLog.record!(actor: current_staff, subject_user_id: @member.user_id)
    rescue ActiveRecord::RecordNotFound
      redirect_to fire_engine_root_path, alert: "no member found for that id"
    end
  end
end
