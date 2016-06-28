class Admin::UserTestPapersController < Admin::ApplicationController
  before_action :authenticate_user!

  def index
    @component_name = "admin_user_test_papers_page"

    user_test_papers = UserTestPaper.all.page(params[:page])
    data = user_test_papers.map do |tr|
      DataFormer.new(tr)
        .logic(:has_completed_reviews)
        .url(:admin_show_url)
        .url(:reviews_url)
        .url(:review_complete_url)
        .data
    end

    @component_data = {
      user_test_papers: data,
      paginate: {
        total_pages: user_test_papers.total_pages,
        current_page: user_test_papers.current_page,
        per_page: user_test_papers.limit_value
      },
      test_paper_result_completed_index_url: "/admin/test_results/completed_index"
    }
  end

  def review_complete
    user_test_paper = UserTestPaper.find params[:id]
    tpr = user_test_paper.inspect_test_paper_result
    tpr.review_complete!

    data = DataFormer.new(user_test_paper)
      .logic(:has_completed_reviews)
      .url(:admin_show_url)
      .url(:reviews_url)
      .url(:review_complete_url)
      .data

    render json: data
  end

end
