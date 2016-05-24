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

    def _build_test_paper
      sections = [
        ["single_choice", 19, 1],
        ["multi_choice", 19, 2],
        ["bool", 19, 1],
        ["essay", 1, 12],
        ["file_upload", 1, 12],
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
