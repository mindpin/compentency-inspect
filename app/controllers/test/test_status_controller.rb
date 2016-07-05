class Test::TestStatusController < ApplicationController
  def index
    utp = User.first.user_test_paper
    render json: DataFormer.new(utp).logic(:test_wares_index).data
  end

end
