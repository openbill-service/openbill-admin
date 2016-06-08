module ApplicationHelper
  def application_title
    "Openbill Admin #{AppVersion}"
  end

  def humanized_meta(meta)
    content_tag :code, meta
  end
end
