results = QuestionBank::TestPaperResult.where(_status: "REVIEW_COMPLETED")

lines = results.map do |rr|
  score_data = rr.score_data

  # 姓名
  user_name   = rr.user.name
  # 总分
  total_score = score_data[:total_score]

  # 单选题分数
  single_choice_score = 0
  # 多选题分数
  multi_choice_score = 0
  # 论述题分数
  essay_score = 0
  # 画图题分数
  file_upload_score = 0
  score_data[:sections].each do |section|
    case section[:kind]
    when "single_choice"
      single_choice_score = section[:section_total_score]
    when "multi_choice"
      multi_choice_score  = section[:section_total_score]
    when "essay"
      essay_score         = section[:section_total_score]
    when "file_upload"
      file_upload_score   = section[:section_total_score]
    end
  end

  # 总评
  songliang_comment = ""
  xiuyu_comment = ""

  tpprs = QuestionBank::TestPaperResultReview.where(test_paper_result_id: rr.id, _status: "completed")
  tpprs.each do |review|
    xiuyu_comment     = review.comment if review.creator.name == "张修瑜"
    songliang_comment = review.comment if review.creator.name == "宋亮"
  end

  "#{user_name},#{total_score},#{single_choice_score},#{multi_choice_score},#{essay_score},#{file_upload_score},#{songliang_comment},#{xiuyu_comment}"
end

lines.unshift("姓名,总分（总分100分）,单选题（总分60分）,多选题（总分20分）,论述题（总分10分）,画图题（总分10分）,宋亮评价,张修瑜评价")

str = lines.join("\r\n")
IO.write("./export.csv", str)
