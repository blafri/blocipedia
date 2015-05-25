module WikisHelper
  def wiki_creator(wiki)
    if wiki.user.username
      wiki.user.username
    else
      wiki.user.email
    end
  end
end
