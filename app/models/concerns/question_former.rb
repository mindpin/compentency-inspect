module QuestionFormer
  extend ActiveSupport::Concern

  included do

    former "QuestionBank::Question" do
      field :id, ->(instance) {instance.id.to_s}
      field :kind
      field :content

      logic :choices, ->(instance, user) {
        user_ord = (user.created_at.to_i % 43) + 1 
        # 43是随便取的一个素数，
        # 可以随意换个大于选项个数的2~3位的数字代替, 
        # +1为使之不为0
        instance.answer["choices"].sort {|x, y| 
          (x['id'].to_i(36) % user_ord) <=> (y['id'].to_i(36) % user_ord)
        }
      }

      logic :answer, ->(instance, user) {
        tpr = user.inspect_test_paper_result
        return nil if tpr.blank?

        qr = QuestionBank::QuestionRecord.where(test_paper_result_id: tpr.id, question_id: instance.id).first
        return nil if qr.blank?

        if instance.kind.to_sym == :file_upload
          return {
            file_entity_id: qr.answer,
            download_url: FilePartUpload::FileEntity.find(qr.answer).download_url
          }
        end
        return qr.answer
      }


    end

  end
end
