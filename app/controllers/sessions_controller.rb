class SessionsController < Devise::SessionsController
  layout "sign_in"
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    if !self.resource.role.normal?
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      return render :action => :new
    end
    sign_in(resource_name, resource)
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
