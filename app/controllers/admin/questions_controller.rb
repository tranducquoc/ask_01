class Admin::QuestionsController < AdminController

  def index
    @questions = Question.page(params[:page]).per Settings.admin.per_page
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
