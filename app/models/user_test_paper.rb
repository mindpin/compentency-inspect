class UserTestPaper
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :test_paper, class_name: "QuestionBank::TestPaper"

  module UserMethods
    extend ActiveSupport::Concern

    included do
      has_one :user_test_paper
      after_create :_build_test_paper
    end

    def inspect_test_paper_result
      QuestionBank::TestPaperResult.where(user_id: self.id, test_paper_id: self.user_test_paper.test_paper_id).first
    end

    def start_test!
      return if !self.inspect_test_paper_result.blank?

      QuestionBank::TestPaperResult.create(
        user_id: self.id,
        test_paper_id: self.user_test_paper.test_paper_id
      )
    end

    def reset_test!
      tpr = self.inspect_test_paper_result
      return if tpr.blank?
      tpr.destroy
    end

    def save_answer(question, answer)
      tpr = self.inspect_test_paper_result
      return false if tpr.blank?

      question_ids = self.user_test_paper.test_paper.sections.map do |section|
        section.question_ids.map{|id|id.to_s}
      end.flatten
      return false if !question_ids.include?(question.id.to_s)

      qr = tpr.question_records.where(user_id: self.id, question_id: question.id).first
      if qr.blank?
        qr = tpr.question_records.build(
          user: self,
          answer: answer,
          question: question
        )
      else
        qr.answer = answer
      end

      qr.save
    end

    def _build_test_paper
      sections = [
        ["single_choice", 40, 1],
        ["multi_choice", 20, 1],
        ["bool", 5, 1],
        ["essay", 3, 5],
        ["file_upload", 4, 5],
      ].map do |item|
        kind  = item[0]
        count = item[1]
        score = item[2]
        criteria = QuestionBank::Question.with_kind(kind)
        {
          kind: kind,
          min_level: 1,
          max_level: 2,
          score: score,
          question_ids: _random(criteria, count)
        }
      end

      test_paper = QuestionBank::TestPaper.create(
        title: self.login,
        score: 100,
        minutes: 180,
        sections_attributes: sections
      )

      if self.role.normal?
        self.create_user_test_paper(
          test_paper: test_paper
        )
      end
    end

    def _random(criteria, n)
      indexes = (0..criteria.count - 1).to_a.sample(n)
      indexes.map { |index| criteria.skip(index).first.id }
    end

  end
end
