class Test::TestController < ApplicationController
  def show
    @component_name = 'test_show_page'
    @component_data = {
      test_status_url:  test_status_path,
      test_wares_url:   test_wares_data_path,
      test_control_url: test_status_start_path,
      test_save_url:    "/test_wares/save_answer"
    }
  end
end
