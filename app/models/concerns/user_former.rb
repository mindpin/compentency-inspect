module UserFormer
  extend ActiveSupport::Concern

  included do

    former "User" do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :login
      field :role
      field :role_str, ->(instance) {
        {'admin' => '管理员', 'normal' => '测验者'}[instance.role]
      }

      url :admin_sign_in, ->(instance){
        "/admin/sign_in"
      }

      url :admin_sign_out, ->(instance){
        "/admin/sign_out"
      }

      url :admin_edit_url, ->(instance){
        edit_admin_user_path(instance)
      }
    end

  end
end
