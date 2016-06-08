class UserTestPaper
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :test_paper, class_name: "QuestionBank::TestPaper"

  module UserMethods
    extend ActiveSupport::Concern

    included do
      has_one :user_test_paper
    end

    def inspect_test_paper_result
      QuestionBank::TestPaperResult.where(user_id: self.id, test_paper_id: self.user_test_paper.test_paper_id).first
    end

    def start_test!
      if self.user_test_paper.blank?
        self._build_test_paper_for_role_normal_user
      end

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

    def _build_test_paper_for_role_normal_user
      return true if !self.role.normal?

      if ENV["build_all_questions"] == "true"
        _build_test_paper_all_questions
      else
        _build_test_paper
      end
    end

    def _build_test_paper_all_questions
      sections = [
        ["single_choice", -1, 2],
        ["multi_choice", -1, 2],
        ["essay", -1, 5],
        ["file_upload", -1, 5],
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
          question_ids: criteria.to_a.map{|q|q.id}
        }
      end

      test_paper = QuestionBank::TestPaper.create(
        title: self.login,
        score: 100,
        minutes: 120,
        sections_attributes: sections
      )

      if self.role.normal?
        self.create_user_test_paper(
          test_paper: test_paper
        )
      end
    end


    def _build_test_paper
      choice_point_params = {
        "single_choice" => [
          ["语法基础",          3],
          ["常见数据类型",      3],
          ["常用基础类库",      3],
          ["抽象类，接口，继承", 5],
          ["linux命令",        2],
          ["shell脚本",        1],
          ["IP，端口，网络环境基础概念", 1],
          ["spring",       4],
          ["hibernate",    3],
          ["servlet, jsp", 1],
          ["jQuery",       4],
        ],
        "multi_choice" => [
          ["语法基础", 4],
          ["常见数据类型", 1],
          ["常用基础类库", 1],
          ["抽象类，接口，继承", 2],
          ["hibernate", 1],
          ["spring", 1],
        ]
      }

      choice_score_params = {
        "single_choice" => 2,
        "multi_choice"  => 2
      }

      sections_attributes = []

      ["single_choice", "multi_choice"].each do |kind|
        question_ids = []
        choice_point_params[kind].each do |point_params|
          point_name = point_params[0]
          count      = point_params[1]
          criteria   = QuestionBank::Question.with_kind(kind).with_point(point_name)
          question_ids += _random(criteria, count)
        end
        question_ids = question_ids.sort_by{rand(0)}

        sections_attributes.push({
          kind: kind,
          min_level: 1,
          max_level: 2,
          score: choice_score_params[kind],
          question_ids: question_ids
        })
      end

      # essay
      sections_attributes.push({
        kind: "essay",
        min_level: 1,
        max_level: 2,
        score: 5,
        question_ids: _random(QuestionBank::Question.with_kind("essay"), 2)
      })

      sections_attributes.push({
        kind: "file_upload",
        min_level: 1,
        max_level: 2,
        score: 5,
        question_ids: _random(QuestionBank::Question.with_kind("file_upload"), 2)
      })

      test_paper = QuestionBank::TestPaper.create(
        title: self.login,
        score: 100,
        minutes: 120,
        sections_attributes: sections_attributes
      )

      self.create_user_test_paper(
        test_paper: test_paper
      )
    end

    def _random(criteria, n)
      indexes = (0..criteria.count - 1).to_a.sample(n)
      indexes.map { |index| criteria.skip(index).first.id }
    end

  end
end
