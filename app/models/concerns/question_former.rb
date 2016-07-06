module QuestionFormer
  extend ActiveSupport::Concern

  included do

    former "QuestionBank::Question" do
      field :id, ->(instance) {instance.id.to_s}
      field :kind
      field :content
      field :content_format
      field :point_ids, ->(instance){
        instance.point_ids.map(&:to_s)
      }

      logic :choices, ->(instance) {
        instance.answer[:choices]
      }

      logic :answer, ->(instance) {
        return nil
      }

      logic :admin_answer, ->(instance) {
        instance.answer
      }

      logic :point_names, ->(instance){
        instance.points.map(&:name)
      }


      url :admin_edit_url, ->(instance){
        edit_admin_question_path(instance)
      }

    end

  end
end
