class WikisController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  after_action :verify_authorized, except: :index

  def index
    @wikis = policy_scope Wiki
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def edit
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    @colaborators = @wiki.colaborators.includes(:user)
  end

  def show
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

  def create
    @wiki = current_user.wikis.build(wiki_params)
    authorize @wiki

    if @wiki.save
      flash[:notice] = 'New wiki successfully created.'
      redirect_to @wiki
    else
      flash.now[:error] = 'There was a problem saving your new wiki. '\
                          'Please try again.'
      render :new
    end
  end

  def update
    @wiki = Wiki.find(params[:id])
    authorize @wiki

    if @wiki.update_attributes(wiki_params)
      flash[:notice] = 'Wiki updated successfully.'
      redirect_to @wiki
    else
      flash.now[:error] = 'There was a problem updating the wiki. Please try'\
                          ' again'
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    authorize @wiki

    if @wiki.destroy
      flash[:notice] = 'The wiki was deleted successfully.'
      redirect_to wikis_path
    else
      flash.now[:error] = 'There was a problem deleting the wiki! Please '\
                          'try again.'
      render :show
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
