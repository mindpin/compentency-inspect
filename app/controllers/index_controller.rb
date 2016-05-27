class IndexController < ApplicationController
  def index
    if current_user.blank?
      redirect_to "/sign_in"
    else
      redirect_to "/test"
    end
  end
end
