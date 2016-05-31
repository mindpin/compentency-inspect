class Admin::TestPaperResultQuestionReviewsController < Admin::ApplicationController
  def create
    tpr = QuestionBank::TestPaperResult.find params[:test_paper_result_question_review][:test_paper_result_id]
    qr  = QuestionBank::Question.find  params[:test_paper_result_question_review][:question_id]
    score   = params[:test_paper_result_question_review][:score]
    comment = params[:test_paper_result_question_review][:comment]
    tpr.review(current_user).save_question_review(qr, score, comment)
    render json: {
      score: score,
      comment: comment
    }
  end
end
