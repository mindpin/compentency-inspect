class TestWaresController < ApplicationController
  before_action :authenticate_user!

  def data
    ids = [params[:ids]].flatten
    questions = QuestionBank::Question.find ids

    result = questions.map do |question|
      case question.kind.to_sym
      when :single_choice, :multi_choice
        DataFormer.new(question).logic(:choices).logic(:answer, current_user).data
      when :bool, :essay, :file_upload
        DataFormer.new(question).logic(:answer, current_user).data
      end
    end

    render json: result
  end

  def answer
    question = QuestionBank::Question.find params[:id]
    if current_user.save_answer(question, params[:answer])
      render json: { status: 200 }
    else
      render status: 500, json: {status: 500}
    end
  end

  def index
    questions = []
    [
      ["single_choice", 2],
      ["multi_choice", 2],
      ["bool", 2],
      ["essay", 1],
      ["file_upload", 1],
    ].each do |item|
      kind  = item[0]
      count = item[1]
      questions += QuestionBank::Question.with_kind(kind).sample(count)
    end

    @component_data = questions.map do |question|
      case question.kind.to_sym
      when :single_choice, :multi_choice
        DataFormer.new(question).logic(:choices).logic(:answer, current_user).data
      when :bool, :essay, :file_upload
        DataFormer.new(question).logic(:answer, current_user).data
      end
    end

    @component_name = "page_test_wares"
  end
end
