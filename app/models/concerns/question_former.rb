module QuestionFormer
  extend ActiveSupport::Concern

  included do

    former "QuestionBank::Question" do
      field :id, ->(instance) {instance.id.to_s}
      field :kind
      field :content

      logic :choices, ->(instance) {
        instance.answer["choices"]
      }

      logic :answer, ->(instance, user) {
        tpr = user.inspect_test_paper_result
        return nil if tpr.blank?

        qr = QuestionBank::QuestionRecord.where(test_paper_result_id: tpr.id, question_id: instance.id).first
        return nil if qr.blank?

        return qr.answer
      }


    end

  end
end
