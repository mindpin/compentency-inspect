class Admin::TestResultsController < Admin::ApplicationController
  before_action :authenticate_user!

  def show
    tpr = QuestionBank::TestPaperResult.find params[:id]
  end
end
