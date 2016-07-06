class Test::TestWaresController < ApplicationController

  def data
    ids = [params[:ids]].flatten
    questions = ids.map do |id|
      QuestionBank::Question.find id
    end

    result = questions.map do |question|
      case question.kind.to_sym
      when :single_choice, :multi_choice
        DataFormer.new(question).logic(:choices).logic(:answer).data
      when :bool, :essay, :file_upload
        DataFormer.new(question).logic(:answer).data
      end
    end

    render json: result
  end

  def save_answer
    render json: {
      answer: params[:answer],
      filled: true
    }
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
        DataFormer.new(question).logic(:choices).logic(:answer).data
      when :bool, :essay, :file_upload
        DataFormer.new(question).logic(:answer).data
      end
    end

    @component_name = "page_test_wares"
  end
end
