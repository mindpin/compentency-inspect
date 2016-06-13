class Admin::QuestionPointsController < Admin::ApplicationController
  before_action :authenticate_user!

  def index
    @component_name = "admin_question_points_page"

    question_points = QuestionBank::Point.all.page(params[:page])
    data = question_points.map do |tr|
      DataFormer.new(tr)
        .url(:admin_edit_url)
        .data
    end

    @component_data = {
      question_points: data,
      paginate: {
        total_pages: question_points.total_pages,
        current_page: question_points.current_page,
        per_page: question_points.limit_value
      },
      new_question_point_url: new_admin_question_point_path
    }
  end

  def new
    @component_name = 'admin_question_points_new_page'
    @component_data = {
      submit_url: admin_question_points_path,
      cancel_url: admin_question_points_path,
    }
  end

  def create
    question_point = QuestionBank::Point.new question_point_params
    save_model(question_point) do |_question_point|
      DataFormer.new(_question_point)
        .data
    end
  end

  def edit
    question_point = QuestionBank::Point.find params[:id]
    @component_name = 'admin_question_points_edit_page'
    @component_data = {
      question_point: DataFormer.new(question_point)
        .data,
      submit_url: admin_question_point_path(question_point),
      cancel_url: admin_question_points_path,
    }
  end

  def update
    question_point = QuestionBank::Point.find params[:id]
    update_model(question_point, question_point_params) do |_question_point|
      DataFormer.new(_question_point)
        .data
    end
  end

  private

  def question_point_params
    params.require(:question_point).permit(:name)
  end
end

