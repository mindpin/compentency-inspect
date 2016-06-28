module TestPaperResultReviewFormer
  extend ActiveSupport::Concern

  included do

    former "QuestionBank::TestPaperResultReview" do
      field :id, ->(instance) {instance.id.to_s}
      field :user, ->(instance) {
        DataFormer.new(instance.user).data
      }
      field :status

      logic :review, ->(instance){
        DataFormer.new(instance.test_paper_result)
          .logic(:review, instance.user)
          .data[:review]
      }

    end

  end
end
