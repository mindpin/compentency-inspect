class TestController < ApplicationController
  def show
    return render text: '未登录系统，不能进行测验' if current_user.blank?

    @component_name = 'test_show_page'
    @component_data = {
      test_status_url:  test_status_path,
      test_wares_url:   test_wares_data_path,
      test_control_url: test_status_start_path,
      test_save_url:    "/test_wares/save_answer"
    }
  end
end