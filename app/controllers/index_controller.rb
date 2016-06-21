class IndexController < ApplicationController
  def index
    if current_user.blank?
      redirect_to "/sign_in"
    elsif current_user.role.admin?
      redirect_to "/admin/dashboard"
    else
      redirect_to "/test"
    end
  end

  def sample
    json = File.read File.join(Rails.root, 'csm', '理财经理培训.yaml.json')
    data = JSON.parse json

    @component_name = 'csm_sample_page'
    @component_data = {
      data: data
    }
  end
end
