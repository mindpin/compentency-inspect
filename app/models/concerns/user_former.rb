module UserFormer
  extend ActiveSupport::Concern

  included do

    former "User" do
      field :id, ->(instance) {instance.id.to_s}
      field :name

      url :admin_sign_in, ->(instance){
        "/admin/sign_in"
      }

      url :admin_sign_out, ->(instance){
        "/admin/sign_out"
      }
    end

  end
end
