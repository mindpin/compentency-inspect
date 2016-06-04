class Admin::QuestionsController < Admin::ApplicationController
  before_action :authenticate_user!

  def index
    @component_name = "admin_questions_page"

    questions = QuestionBank::Question.all.desc(:id).page(params[:page])
    data = questions.map do |tr|
      DataFormer.new(tr)
        .logic(:admin_answer)
        .url(:admin_edit_url)
        .data
    end

    @component_data = {
      questions: data,
      paginate: {
        total_pages: questions.total_pages,
        current_page: questions.current_page,
        per_page: questions.limit_value
      },
      new_question_url: new_admin_question_path
    }
  end

  def new
    if %w[single_choice multi_choice bool essay file_upload].include? params[:kind]
      @component_name = "admin_questions_new_#{params[:kind]}_page"
    else
      return redirect_to admin_questions_path
    end

    @component_data = {
      submit_url: admin_questions_path,
      cancel_url: admin_questions_path,
    }
  end

  def create
    question = QuestionBank::Question.new question_params
    case question.kind.to_sym
    when :single_choice, :multi_choice
      question.answer["choices"] = question.answer["choices"].values
    end
    save_model(question) do |_question|
      DataFormer.new(_question)
        .data
    end
  end

  def edit
    question = QuestionBank::Question.find params[:id]
    @component_name = 'admin_questions_edit_page'
    @component_data = {
      question: DataFormer.new(question)
        .data,
      submit_url: admin_question_path(question),
      cancel_url: admin_questions_path,
    }
  end

  def update
    question = QuestionBank::Question.find params[:id]
    update_model(question, question_params) do |_question|
      DataFormer.new(_question)
        .data
    end
  end

  private

  def question_params
    params.require(:question).permit(:content, :answer, :kind, :level, :answer => [:correct, :choices => [:id, :text], :corrects => []])
  end
end
