module ApplicationHelper
  SWITCH_LANGS = {en: :vi, vi: :en}.freeze

  def locale_image
    lang = SWITCH_LANGS[I18n.locale.to_sym]
    link_to image_tag("#{lang}.png"), locale: lang
  end
end
