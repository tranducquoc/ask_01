class Admin::QuestionsController < AdminController

  def index
    @questions = Question.includes([:user, :topics])
      .page(params[:page]).per Settings.admin.per_page;
    respond_to do |format|
      format.html
      format.csv {send_data @questions.to_csv}
    end
  end

  def show
    @question = Question.find_by id: params[:id]
    unless @question
      flash[:danger] = t "flash.admin.question.not_found"
      redirect_to :back
    end
  end

  def destroy
    result = Question.destroy params[:id]
    if result.nil?
      flash[:danger] = t "flash.admin.question.delete.failed"
      redirect_to :back
    else
      flash[:success] = t "flash.admin.topic.delete.success"
      redirect_to admin_questions_path
    end
  end
end
