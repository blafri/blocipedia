# Public: This controller handles adding and removing colaborators for wikis
class ColaboratorsController < ApplicationController
  def create
    user = User.find_by_email(params[:colaborator_email])
    wiki = Wiki.find(params[:wiki_id])
    colaborator = Colaborator.new(user: user, wiki: wiki)

    if colaborator.save
      flash[:notice] = params[:colaborator_email] +
                       ' successfully added as a colaborator.'
    else
      flash[:error] = colaborator.errors.full_messages.join(' ')
                      .sub('User', params[:colaborator_email])
    end

    redirect_to edit_wiki_path(wiki)
  end

  def destroy
    colaborator = Colaborator.find(params[:id])
    wiki = Wiki.find(params[:wiki_id])

    if colaborator.destroy
      flash[:notice] = 'Colaborator was deleted successfully'
    else
      flash[:error] = 'There was a problem deleting the colaborator. Please '\
                      'try again.'
    end
    redirect_to edit_wiki_path(wiki)
  end
end
