class Admin::TestResultsController < Admin::ApplicationController
  before_action :authenticate_user!

  def show
    @component_name = "admin_test_result_show_page"
    tpr = QuestionBank::TestPaperResult.find params[:id]
    @component_data = DataFormer.new(tpr).logic(:test_paper, current_user).data
  end
end
