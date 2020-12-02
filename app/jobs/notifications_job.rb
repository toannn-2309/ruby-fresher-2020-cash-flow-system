class NotificationsJob < ApplicationJob
  queue_as :default

  def perform receiver_id
    receiver = User.find receiver_id
    notifications = receiver.notifications.includes(:sender).order_created_at_desc.limit(Settings.limit_noti)
    view_noti = ApplicationController.render partial: "layouts/notifications",
                                             collection: notifications, as: :noti
    ActionCable.server.broadcast "notifications_channel:#{receiver_id}",
                                 view_noti:  view_noti,
                                 counter: receiver.notifications.unread.size
  end
end
