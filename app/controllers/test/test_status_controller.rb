class Test::TestStatusController < ApplicationController
  def index
    render json: DataFormer.new(UserTestPaper.first).logic(:test_wares_index).data
  end

end
