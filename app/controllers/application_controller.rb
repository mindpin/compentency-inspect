class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if params[:controller] == "admin/sessions"
      return "/admin/dashboard"
    end
    "/"
  end

  def after_sign_out_path_for(resource)
    if params[:controller] == "admin/sessions"
      return "/admin/sign_in"
    end
    "/"
  end

  # 覆盖 rails 默认的 render :template => params[:action] 行为
  # 改为
  # 如果 @component_name @component_data 存在就 render "/react/page"
  # 如果 @component_name @component_data 不存在就使用 rails 默认的 render :template => params[:action] 行为
  def default_render(*args)
    if @component_name.present? && @component_data.present?
      @component_name = @component_name.camelize
      return render "/react/page"
    else
      super
    end
  end
end
