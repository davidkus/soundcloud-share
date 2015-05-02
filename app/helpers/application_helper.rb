module ApplicationHelper

  def error_messages(resource)
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:div, msg, class: "item") }.join
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class="ui error message">
      <div class="header">#{sentence}</div>
      <div class="ui bulleted list">
        #{messages}
      </div>
    </div>
    HTML

    html.html_safe
  end

end
