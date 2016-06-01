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
        .data
    end

    @component_data = {
      user_test_papers: data,
      paginate: {
        total_pages: user_test_papers.total_pages,
        current_page: user_test_papers.current_page,
        per_page: user_test_papers.limit_value
      }
    }
  end
end
