class Admin::TopicsController < AdminController

  def index
    @topics = Topic.lastest.page(params[:page]).per Settings.admin.per_page
    respond_to do |format|
      format.html
      format.csv {send_data @topics.to_csv}
    end
  end

  def new
    @topic = Topic.new
  end

  def edit
    @topic = Topic.find_by id: params[:id]
    unless @topic
      flash[:danger] = t "flash.admin.topic.not_found"
      redirect_to admin_topics_path
    end
  end

  def update
    @topic = Topic.find_by slug: params[:id]
    unless @topic
      flash[:danger] = t "flash.admin.topic.not_found"
      redirect_to admin_topics_path
    end
    if @topic.update_attributes topic_params
      flash[:success] = t "flash.admin.topic.update.success"
      redirect_to admin_topics_path
    else
      flash[:danger] = t "flash.admin.topic.update.failed"
      render :edit
    end
  end

  def destroy
    @topic = Topic.destroy params[:id]
    if @topic.destroyed?
      flash[:success] = t "flash.admin.topic.delete.success"
      redirect_to admin_topics_path
    else
      flash[:danger] = t "flash.admin.topic.delete.failed"
      redirect_to :back
    end
  end

  def create
    @topic = Topic.new topic_params
    if @topic.save
      flash[:success] = t "flash.admin.topic.create.success"
      redirect_to admin_topics_path
    else
      flash[:danger] = t "flash.admin.topic.create.failed"
      redirect_to :back
    end
  end

  private
  def topic_params
    params.require(:topic).permit :icon, :name, :description
  end
end
