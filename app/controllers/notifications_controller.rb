class NotificationsController < ApplicationController
  def update
    @notifications.unread.update status: "read"
    redirect_back fallback_location: root_path
  end
end
