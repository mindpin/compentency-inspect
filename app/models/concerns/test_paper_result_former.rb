module TestPaperResultFormer
  extend ActiveSupport::Concern

  included do

    former "QuestionBank::TestPaperResult" do
      field :id, ->(instance) {instance.id.to_s}
      field :user, ->(instance) {
        DataFormer.new(instance.user).data
      }

      field :status, ->(instance) {
        return "RUNNING"   if Time.now < instance.created_at + instance.test_paper.minutes.minutes
        return "FINISHED"
      }

      logic :test_paper, ->(instance, reviewer) {
        tp = instance.test_paper
        sections = tp.sections.map do |section|
          {
            kind:  section.kind,
            score: section.score,
            test_wares: section.questions.map do |question|
              hash = {
                id:   question.id.to_s,
                kind: question.kind,
                content: question.content
              }

              case question.kind
              when "bool"
                status = instance.question_answer_status(question)
                is_correct  = status[:is_correct]
                user_answer = status[:answer]
                hash.merge!({
                  correct_answer: question.answer,
                  user_answer: user_answer,
                  is_correct: is_correct
                })
              when "single_choice"
                status = instance.question_answer_status(question)
                is_correct  = status[:is_correct]
                user_answer = status[:answer]
                hash.merge!({
                  choices: question.answer["choices"],
                  correct_answer: question.answer["correct"],
                  user_answer: user_answer,
                  is_correct: is_correct
                })
              when "multi_choice"
                status = instance.question_answer_status(question)
                is_correct  = status[:is_correct]
                user_answer = status[:answer]
                hash.merge!({
                  choices: question.answer["choices"],
                  correct_answer: question.answer["corrects"],
                  user_answer: user_answer,
                  is_correct: is_correct
                })
              when "essay", "file_upload"
                status = instance.question_review_status(question, reviewer)
                score = status[:score]
                comment = status[:comment]
                hash.merge!({
                  test_paper_result_id: instance.id.to_s,
                  create_test_paper_result_question_review_url: "/admin/test_paper_result_question_reviews",
                  max_score: section.score,
                  user_answer: instance.question_answer_status(question)[:answer],
                  score: score,
                  comment: comment
                })
              end

              hash
            end
          }
        end

        {
          test_paper_result_id: instance.id.to_s,
          review_comment: instance.review_comment(reviewer),
          create_test_paper_result_review_url: "/admin/test_paper_result_reviews",
          sections: sections
        }
      }

    end

  end
end
