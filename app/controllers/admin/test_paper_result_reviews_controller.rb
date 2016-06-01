class Admin::TestPaperResultReviewsController < Admin::ApplicationController
  def create
    tpr = QuestionBank::TestPaperResult.find params[:test_paper_result_review][:test_paper_result_id]
    comment = params[:test_paper_result_review][:comment]
    review = tpr.review(current_user)
    review.comment = comment
    review.save
    render json: {
      comment: comment
    }
  end

  def complete
    tpr = QuestionBank::TestPaperResult.find params[:test_paper_result_id]
    review = tpr.review(current_user)
    review.complete!
    render json: {status: review.status}
  end
end
