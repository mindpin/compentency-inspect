QuestionBank::TestPaperResult.class_eval do
  def question_answer_status(question)
    qr = self.question_records.where(user_id: user.id, question_id: question.id).first

    if qr.blank?
      return {
        answer: nil,
        filled: false
      }
    end

    if qr.kind == "bool"
      return {
        answer: qr.answer,
        filled: !qr.answer.nil?
      }
    end

    return {
      answer: qr.answer,
      filled: qr.answer.present?
    }
  end

  def reivew(user)
    reivew = QuestionBank::TestPaperResultReview.where(
      user_id: user.id,
      test_paper_result_id: self.id
    ).first

    if reivew.blank?
      reivew = QuestionBank::TestPaperResultReview.create(
        user_id: user.id,
        test_paper_result_id: self.id
      )
    end
    reivew
  end
end
