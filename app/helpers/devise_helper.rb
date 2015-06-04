module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages
               .map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
<div class='alert alert-danger'>
  <ul class='list-unstyled'>
    #{messages}
  </ul>
</div>
HTML

    html.html_safe
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end

  # Internal: Generates the link for the user to upgrade/downgrade their account
  #
  # user - A User object for the user you would like to generate the link for
  #
  # Returns a String containg a valid link to upgrade the users account
  def account_upgrade_link(user)
    if user.role == 'standard'
      link_to 'Upgrade Account', upgrade_path,
              class: 'btn btn-success', id: 'upgrade-account-link'
    elsif user.role == 'premium'
      link_to 'Downgrade Account', refund_path,
              class: 'btn btn-success', id: 'upgrade-account-link',
              method: :post,
              data: {
                confirm: 'Are you sure you want to downgrade your account. All'\
                         ' your private wikis will be converted to public'
              }
    end
  end
end
