class Admin::QuestionRecordReviewsController < Admin::ApplicationController
  def create
    tpr = QuestionBank::TestPaperResult.find params[:question_record_review][:test_paper_result_id]
    qr  = QuestionBank::QuestionRecord.find  params[:question_record_review][:question_record_id]
    score   = params[:question_record_review][:score]
    comment = params[:question_record_review][:comment]
    tpr.review(current_user).save_question_record_review(qr, score, comment)
    render json: {
      score: score,
      comment: comment
    }
  end
end
