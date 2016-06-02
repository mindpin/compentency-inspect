class Admin::UsersController < Admin::ApplicationController
  before_action :authenticate_user!

  def index
    @component_name = "admin_users_page"

    users = User.all.page(params[:page])
    data = users.map do |user|
      DataFormer.new(user)
        .url(:admin_edit_url)
        .data
    end

    @component_data = {
      users: data,
      paginate: {
        total_pages: users.total_pages,
        current_page: users.current_page,
        per_page: users.limit_value
      },
      new_user_url: new_admin_user_path
    }
  end

  def new
    @component_name = 'admin_users_new_page'
    @component_data = {
      submit_url: admin_users_path,
      cancel_url: admin_users_path,
    }
  end

  def create
    user = User.new user_params
    save_model(user) do |_user|
      DataFormer.new(_user)
        .data
    end
  end

  def edit
    user = User.find params[:id]
    @component_name = 'admin_users_edit_page'
    @component_data = {
      user: DataFormer.new(user)
        .data,
      submit_url: admin_user_path(user),
      cancel_url: admin_users_path,
    }
  end

  def update
    user = User.find params[:id]
    update_model(user, user_params) do |_user|
      DataFormer.new(_user)
        .data
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :login, :role, :password)
  end
end
