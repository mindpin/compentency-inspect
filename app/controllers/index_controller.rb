class IndexController < ApplicationController
  def index
    if current_user.blank?
      return "/sign_in"
    else
      return "/test"
    end
  end
end
