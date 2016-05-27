module TestPaperResultFormer
  extend ActiveSupport::Concern

  included do

    former "QuestionBank::TestPaperResult" do
      field :id, ->(instance) {instance.id.to_s}
      field :user, ->(instance) {
        DataFormer.new(instance.user).data
      }

    end

  end
end
