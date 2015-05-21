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
  
  def account_links
    if user_signed_in?
      name = current_user.username ? current_user.username : current_user.email
      html = "Welcome " + link_to(name, edit_user_registration_path)  + ' | ' +
        link_to("Log Out", destroy_user_session_path, method: :delete)
    else
      html = link_to("Create Account", new_user_registration_path) + ' | ' +
        link_to("Log In", new_user_session_path)
    end
    
    html.html_safe
  end
  
  def display_form_errors!(resource)
    return "" if resource.errors.empty?
    
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    
    html = <<-START
<div class='alert alert-danger'>
  <ul class='list-unstyled'>
    #{messages}
  </ul>
</div>
START
    
    html.html_safe
  end
  
  def is_link_active(link_path)
    if current_page?(link_path)
      return 'active'
    else
      return ''
    end
  end
end
