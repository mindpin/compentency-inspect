class QuestionBank::TestPaperResultReview
  include Mongoid::Document
  include Mongoid::Timestamps

  field :comment, type: String

  belongs_to :user
  belongs_to :test_paper_result, class_name: "QuestionBank::TestPaperResult"

  has_many :question_record_reivews, class_name: "QuestionBank::QuestionRecordReview"

  def save_question_record_review(question_record, score, comment)
    qrr = self.question_record_reivews.where(question_record_id: question_record.id).first
    if qrr.blank?
      qrr = self.question_record_reivews.create(
        question_record_id: question_record.id,
        score: score,
        comment: comment
      )
    else
      qrr.score = score
      qrr.comment = comment
      qrr.save
    end
  end
end
