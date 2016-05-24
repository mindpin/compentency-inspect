class TestStatusController < ApplicationController
  before_action :authenticate_user!

  def index
    user_test_paper = current_user.user_test_paper
    data = DataFormer.new(user_test_paper).data
    render json: data
  end

  def start
    current_user.start_test!
    render json: {
      status: 200
    }
  end
end
