class Admin::TestResultsController < Admin::ApplicationController
  before_action :authenticate_user!

  def show
    @component_name = "admin_test_result_show_page"
    tpr = QuestionBank::TestPaperResult.find params[:id]
    @component_data = DataFormer.new(tpr)
      .logic(:test_paper)
      .logic(:review, current_user)
      .url(:create_question_review_url)
      .url(:create_review_url)
      .url(:set_review_complete_url)
      .data
  end

  def reviews
    @component_name = "admin_test_result_reviews_page"
    tpr = QuestionBank::TestPaperResult.find params[:id]
    @component_data = DataFormer.new(tpr)
      .logic(:test_paper)
      .logic(:review_result)
      .data
  end
end
