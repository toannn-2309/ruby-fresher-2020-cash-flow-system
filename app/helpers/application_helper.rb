module ApplicationHelper
  SWITCH_LANGS = {en: :vi, vi: :en}.freeze
  MESSAGE = {success: "success", danger: "error", info: "info",
             warning: "warning", notice: "success", alert: "error"}.freeze

  def locale_image
    lang = SWITCH_LANGS[I18n.locale.to_sym]
    link_to image_tag("#{lang}.png"), locale: lang
  end

  def custom_flash
    flash_messages = []
    flash.each do |type, message|
      type = MESSAGE[type.to_sym]
      text = content_tag(:script, sanitize("toastr.#{type}('#{message}');"))
      flash_messages << text if message
    end
    safe_join flash_messages
  end
end
