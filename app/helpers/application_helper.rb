module ApplicationHelper
  def form_group_tag(errors, glyphicon = true, &block)
    if !errors.any?
      return content_tag :div, capture(&block), class: 'form-group'
    end
      
    if glyphicon
      extra_html = content_tag(:span, '', class: 'glyphicon glyphicon-remove form-control-feedback')
    else
      extra_html = ''
    end
    
    content_tag(:div, capture(&block) + extra_html, class: 'form-group has-error has-feedback')
  end
end
