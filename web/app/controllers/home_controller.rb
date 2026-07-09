class HomeController < ApplicationController
  before_action :require_community_manager

  def index
  end

  private

  def require_community_manager
    return if current_staff.community_manager?

    redirect_to fire_engine_root_path
  end
end
