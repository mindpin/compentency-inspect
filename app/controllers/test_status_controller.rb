class TestStatusController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: DataFormer.new(current_user.user_test_paper).data
  end

  def start
    current_user.start_test!

    user_test_paper = current_user.user_test_paper
    render json: DataFormer.new(current_user.user_test_paper).data
  end
end
