module QuestionPointFormer
  extend ActiveSupport::Concern

  included do

    former "QuestionBank::Point" do
      field :id, ->(instance) {instance.id.to_s}
      field :name

      url :admin_edit_url, ->(instance){
        edit_admin_question_point_path(instance)
      }
    end

  end
end

