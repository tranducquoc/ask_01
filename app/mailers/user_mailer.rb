class UserMailer < ApplicationMailer
  def notifyAnswer question
    @question = question
    mail to: question.user.email, subject: t("email.notify_new_answer")
  end

  def sumQuestionLastDay email, topics
    @topics = topics
    mail to: email, subject: t("email.have_new_question_in_topic")
  end
end
