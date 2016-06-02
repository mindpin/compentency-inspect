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
end
