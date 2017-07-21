class ActivitiesController < ApplicationController
  def index
    @activities_by_owner = PublicActivity::Activity.where(owner: current_user)
    @activities = PublicActivity::Activity.order("created_at Desc")
  end
end
