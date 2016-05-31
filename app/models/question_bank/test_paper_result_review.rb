class QuestionBank::TestPaperResultReview
  include Mongoid::Document
  include Mongoid::Timestamps

  field :comment, type: String

  belongs_to :user
  belongs_to :test_paper_result, class_name: "QuestionBank::TestPaperResult"

  has_many :question_record_reivews, class_name: "QuestionBank::QuestionRecordReview"
end
