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
                content: question.content,
                content_format: question.content_format
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
                  choices: question.sorted_choices(instance.user),
                  correct_answer: question.answer["correct"],
                  user_answer: user_answer,
                  is_correct: is_correct
                })
              when "multi_choice"
                status = instance.question_answer_status(question)
                is_correct  = status[:is_correct]
                user_answer = status[:answer]
                hash.merge!({
                  choices: question.sorted_choices(instance.user),
                  correct_answer: question.answer["corrects"],
                  user_answer: user_answer,
                  is_correct: is_correct
                })
              when "essay"
                hash.merge!({
                  max_score: section.score,
                  user_answer: instance.question_answer_status(question)[:answer]
                })
              when "file_upload"
                id = instance.question_answer_status(question)[:answer]
                fe = FilePartUpload::FileEntity.find id
                hash.merge!({
                  max_score: section.score,
                  user_answer: fe.download_url
                })
              end

              hash
            end
          }
        end

        {sections: sections}
      }

      logic :review, ->(instance, reviewer) {
        review_status = instance.review_status(reviewer)
        question_reviews = []
        instance.test_paper.sections.each do |section|
          section.questions.each do |question|
            if question.kind == "essay" || question.kind ==  "file_upload"
              status = instance.question_review_status(question, reviewer)
              question_reviews.push({
                question_id: question.id.to_s,
                score: status[:score],
                comment: status[:comment]
              })
            end
          end
        end

        {
          status: review_status[:status],
          comment: review_status[:comment],
          test_ware_reviews: question_reviews
        }
      }

      url :create_question_review_url, ->(instance){
        "/admin/test_paper_result_question_reviews"
      }

      url :create_review_url, ->(instance){
        "/admin/test_paper_result_reviews"
      }

      url :set_review_complete_url, ->(instance){
        "/admin/test_paper_result_reviews/complete"
      }
    end



  end
end
