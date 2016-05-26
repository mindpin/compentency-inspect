class TestController < ApplicationController
  def show
    return render text: '未登录系统，不能进行测验' if current_user.blank?

    @component_name = 'test_show_page'
    @component_data = {
      aaa: 1
    }
  end
end