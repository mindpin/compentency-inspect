class TestController < ApplicationController
  def show
    return render text: '未登录系统，不能进行测验' if current_user.blank?

    @component_data = {}
  end
end