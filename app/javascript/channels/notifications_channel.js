import consumer from './consumer'

document.addEventListener('turbolinks:load', () => {
  consumer.subscriptions.create({channel: 'NotificationsChannel'}, {
    connected() {},
    disconnected() {},
    received(data) {
      $('#notification-counter').html(data.counter)
      $('#notification-list').html(data.view_noti)
    }
  });
})
