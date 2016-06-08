class TestStatusController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.user_test_paper.blank?
      data = {
        current_user: {
          id:   current_user.id.to_s,
          name: current_user.name
        },
        status: "NOT_START"
      }
      render json: data
    else
      render json: DataFormer.new(current_user.user_test_paper).data
    end
  end

  def start
    current_user.start_test!

    user_test_paper = current_user.user_test_paper
    render json: DataFormer.new(current_user.user_test_paper).data
  end
end
