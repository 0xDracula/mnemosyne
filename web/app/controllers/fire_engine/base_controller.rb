module FireEngine
  class BaseController < ApplicationController
    layout "fire_engine"

    before_action :require_fire_engine_access

    private

    def require_fire_engine_access
      return if current_staff.community_manager? || current_staff.firefighter?

      redirect_to root_path, alert: "you don't have access to Fire Engine"
    end
  end
end
