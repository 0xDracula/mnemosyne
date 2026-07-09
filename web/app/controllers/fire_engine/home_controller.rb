module FireEngine
  class HomeController < BaseController
    def index
      if params[:q].present?
        q = params[:q].strip
        @results = Moderation::MemberProfile
          .where("user_id = :exact OR username ILIKE :like OR email ILIKE :like OR name ILIKE :like",
                 exact: q, like: "%#{q}%")
          .order(:user_id)
          .limit(25)
      end

      @recent = AccessLog.where(actor_id: current_staff.user_id).order(looked_at: :desc).limit(10)
    end
  end
end
