class RequestMailer < ApplicationMailer
  def request_mail request, type
    @user = request.user
    @request = request
    @type = type
    mail(to: @user.email,
      subject: (type.zero? ? t("admin.sbj_paid") : t("admin.sbj_rejected")))
  end
end
