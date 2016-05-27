module UserTestPaperFormer
  extend ActiveSupport::Concern

  included do

    former "UserTestPaper" do
      field :current_user, ->(instance) {
        {
          id:   instance.user_id.to_s,
          name: instance.user.name
        }
      }

      field :status, ->(instance) {
        tpr = instance.user.inspect_test_paper_result
        return "NOT_START" if tpr.blank?
        return "RUNNING"   if Time.now < tpr.created_at + instance.test_paper.minutes.minutes
        return "FINISHED"
      }

      field :deadline_time, ->(instance) {
        tpr = instance.user.inspect_test_paper_result
        return 0 if tpr.blank?
        time = tpr.created_at + instance.test_paper.minutes.minutes
        time.to_i
      }

      field :remain_seconds, ->(instance) {
        tpr = instance.user.inspect_test_paper_result
        return 0 if tpr.blank?
        time = tpr.created_at + instance.test_paper.minutes.minutes - Time.now
        time.to_i
      }

      field :test_wares_index, ->(instance) {
        instance.test_paper.sections.map do |section|
          {
            kind: section.kind,
            score: section.score,
            test_wares: section.question_ids.map(&:to_s)
          }
        end
      }

      url :admin_show_url, ->(instance) {
        "/admin/test_results/#{instance.id}"
      }
    end

  end
end
