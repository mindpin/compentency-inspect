class TestWaresController < ApplicationController
  before_action :authenticate_user!

  def data
    ids = [params[:ids]].flatten
    questions = QuestionBank::Question.find ids

    result = questions.map do |question|
      case question.kind.to_sym
      when :single_choice, :multi_choice
        DataFormer.new(question).logic(:choices, current_user).data
      when :bool, :essay, :file_upload
        DataFormer.new(question).data
      end
    end

    render json: result
  end
end
