module WikisHelper
  def wiki_creator(wiki)
    if wiki.user.username
      wiki.user.username
    else
      wiki.user.email
    end
  end
  
  def wiki_submit_text(action)
    case action
    when "new"
      "Create Wiki"
    when "edit"
      "Update Wiki"
    end
  end
end
