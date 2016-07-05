module UserTestPaperFormer
  extend ActiveSupport::Concern

  included do

    former "UserTestPaper" do
      field :id, ->(instance) {instance.id.to_s}
      field :current_user, ->(instance) {
        {
          id:   instance.user_id.to_s,
          name: instance.user.name
        }
      }

      field :status, ->(instance) {
        return "RUNNING"
      }

      field :deadline_time, ->(instance) {
        time = Time.now + instance.test_paper.minutes.minutes
        time.to_i
      }

      field :remain_seconds, ->(instance) {
        time = instance.test_paper.minutes.minutes
        time.to_i
      }

      logic :test_wares_index, ->(instance) {
        instance.test_paper.sections.map do |section|
          {
            kind: section.kind,
            score: section.score,
            test_wares: section.questions.map do |question|
              filled = false
              tpr = instance.user.inspect_test_paper_result

              if tpr.blank?
                filled = false
              else
                answer_status = tpr.question_answer_status(question)
                filled = answer_status[:filled]
              end

              {
                id: question.id.to_s,
                filled: filled
              }
            end
          }
        end
      }

    end

  end
end
