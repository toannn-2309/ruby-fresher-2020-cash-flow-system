class SendMailWorker
  include Sidekiq::Worker

  def perform request_id, type
    request = Request.find_by id: request_id
    return if request.blank?

    RequestMailer.request_mail(request, type).deliver_now
  end
end
