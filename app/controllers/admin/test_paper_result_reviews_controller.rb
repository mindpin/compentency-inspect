class Admin::TestPaperResultReviewsController < Admin::ApplicationController
  def create
    tpr = QuestionBank::TestPaperResult.find params[:test_paper_result_review][:test_paper_result_id]
    review_comment = params[:test_paper_result_review][:review_comment]
    review = tpr.review(current_user)
    review.comment = review_comment
    review.save
    render json: {
      review_comment: review_comment
    }
  end
end
