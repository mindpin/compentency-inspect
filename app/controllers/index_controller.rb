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
    @component_name = 'list_sample_page'
    @component_data = {
      items: [
        {id: 'id1', published: false},
        {id: 'id2', published: false},
        {id: 'id3', published: true},
        {id: 'id4', published: true},
        {id: 'id5', published: false},
      ]
    }
  end
end
