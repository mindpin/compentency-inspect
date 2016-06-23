class IndexController < ApplicationController
  layout 'csm'

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
    data = YAML.load_file File.join(Rails.root, 'csm', 'yaml', '理财经理培训.yaml')

    @component_name = 'csm_sample_page'
    @component_data = {
      data: data
    }
  end

  def getmd
    file = params[:file]
    text = File.read File.join(Rails.root, 'csm', 'yaml', 'markdowns', file)
    render text: text
  end

  def getimgs
    file = params[:file]
    text = File.read File.join(Rails.root, 'csm', 'yaml', 'images', file)
    render json: text.lines
  end
end
