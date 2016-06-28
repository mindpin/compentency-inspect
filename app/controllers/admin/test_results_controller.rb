class Admin::TestResultsController < Admin::ApplicationController
  before_action :authenticate_user!, only: [:show]

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
    if current_user.blank?
      @component_name = @component_name.camelize
      render layout: "guest", template: "react/page"
    end
  end

  def completed_index
    results = QuestionBank::TestPaperResult.where(_status: "REVIEW_COMPLETED").page(params[:page])
    @component_name = "admin_test_result_completed_index_page"
    result_data     = results.map do |rr|
      score_data = rr.score_data
      {
        id: rr.id.to_s,
        user: DataFormer.new(rr.user).data,
        total_score: score_data[:total_score],
        sections: score_data[:sections],
        desc_url: "/admin/test_results/#{rr.id}/reviews"
      }
    end

    @component_data = {
      results: result_data,
      paginate: {
        total_pages: results.total_pages,
        current_page: results.current_page,
        per_page: results.limit_value
      }
    }
    if current_user.blank?
      @component_name = @component_name.camelize
      render layout: "guest", template: "react/page"
    end
  end
end
