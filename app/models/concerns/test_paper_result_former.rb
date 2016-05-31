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
                is_correct  = false
                user_answer = nil
                qr = QuestionBank::QuestionRecord.where(test_paper_id: instance.id, question_id: question.id, user_id: instance.user_id).first
                if !qr.blank?
                  is_correct = qr.is_correct
                  user_answer = qr.answer
                end
                hash.merge!({
                  correct_answer: question.answer,
                  user_answer: user_answer,
                  is_correct: is_correct
                })
              when "single_choice"
                is_correct  = false
                user_answer = nil
                qr = QuestionBank::QuestionRecord.where(test_paper_id: instance.id, question_id: question.id, user_id: instance.user_id).first
                if !qr.blank?
                  is_correct = qr.is_correct
                  user_answer = qr.answer
                end
                hash.merge!({
                  choices: question.answer["choices"],
                  correct_answer: question.answer["correct"],
                  user_answer: user_answer,
                  is_correct: is_correct
                })
              when "multi_choice"
                is_correct  = false
                user_answer = nil
                qr = QuestionBank::QuestionRecord.where(test_paper_id: instance.id, question_id: question.id, user_id: instance.user_id).first
                if !qr.blank?
                  is_correct = qr.is_correct
                  user_answer = qr.answer
                end
                hash.merge!({
                  choices: question.answer["choices"],
                  correct_answer: question.answer["corrects"],
                  user_answer: user_answer,
                  is_correct: is_correct
                })
              when "essay", "file_upload"
                score = -1
                comment = nil
                user_answer = nil
                qr = QuestionBank::QuestionRecord.where(test_paper_id: instance.id, question_id: question.id, user_id: instance.user_id).first
                if !qr.blank?
                  user_answer = qr.answer

                  tprr = QuestionBank::TestPaperResultReview.where(test_paper_result_id: instance.id, user_id: reviewer.id).first
                  if !tprr.blank?
                    qrr = QuestionBank::QuestionRecordReview.where(question_record_id: qr.id, test_paper_result_review_id: tprr.id).first
                    if !qrr.blank?
                      score = qrr.score
                      comment = qrr.comment
                    end
                  end
                end
                hash.merge!({
                  user_answer: user_answer,
                  score: score,
                  comment: comment
                })
              end

              hash
            end
          }
        end

        {sections: sections}
      }

    end

  end
end
