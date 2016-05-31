class QuestionBank::QuestionRecordReview
  include Mongoid::Document
  include Mongoid::Timestamps

  field :score,   type: Integer
  field :comment, type: String

  belongs_to :question_record,          class_name: "QuestionBank::QuestionRecord"
  belongs_to :test_paper_result_review, class_name: "QuestionBank::TestPaperResultReview"

end
