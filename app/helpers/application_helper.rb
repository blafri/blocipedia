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
  
  # Public: This methods users the redcarpet gem to parse markdown text to HTML
  #
  # markdown_text - String containg the markdown do be converted to html
  #
  # Examples
  #
  #   markdown_to_html('# This is a title')
  #   # => <h1>This is a title</h1>
  #
  # Returns a String containg the html generated from the markdown text
  def markdown_to_html(markdown_text)
    renderer = Redcarpet::Render::HTML.new(
      escape_html: true,
      safe_links_only: true,
      with_toc_data: true,
      hard_wrap: true)
    
    redcarpet = Redcarpet::Markdown.new(renderer,
      tables: true,
      autolink: true,
      strikethrough: true,
      superscript: true,
      underline: true,
      highlight: true)
    
    (redcarpet.render markdown_text).html_safe
  end
end
