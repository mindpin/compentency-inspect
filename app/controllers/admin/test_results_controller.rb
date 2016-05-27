class Admin::TestResultsController < Admin::ApplicationController
  before_action :authenticate_user!

  def index
    @component_name = "admin_test_results_page"

    test_results = UserTestPaper.all.page(params[:page])
    data = test_results.map do |tr|
      DataFormer.new(tr).url(:admin_show_url).data
    end

    @component_data = {
      test_results: data,
      paginate: {
        total_pages: test_results.total_pages,
        current_page: test_results.current_page,
        per_page: test_results.limit_value
      }
    }
  end
end
