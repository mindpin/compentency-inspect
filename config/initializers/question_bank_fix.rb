QuestionBank::TestPaperResult.class_eval do
  def question_answer_status(question)
    qr = self.question_records.where(user_id: user.id, question_id: question.id).first

    if qr.blank?
      return {
        answer: nil,
        filled: false
      }
    end

    return {
      answer: qr.answer,
      filled: qr.answer.present?
    }
  end
end