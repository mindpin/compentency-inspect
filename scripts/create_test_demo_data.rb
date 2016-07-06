def import(questions_json_file)
  result = []
  question_hash = JSON.parse(questions_json_file)
  questions = question_hash['question']
  questions.each do |question|
    question[:level] = "1"
    item = QuestionBank::Question.new(question)
    item.save
    result.push item
  end
  result
end

user = User.create(login: "zhangsan", name: "张三", password: 123456, role: "normal")

single_questions_json_file = IO.read(File.expand_path("../json/single_choice.json", __FILE__))
single_questions = import(single_questions_json_file)

multi_questions_json_file = IO.read(File.expand_path("../json/multi_choice.json",   __FILE__))
multi_questions  = import(multi_questions_json_file)


sections_attributes = []
sections_attributes.push({
  kind: "single_choice",
  min_level: 1,
  max_level: 2,
  score: 5,
  question_ids: single_questions.map{|q|q.id}
})
sections_attributes.push({
  kind: "multi_choice",
  min_level: 1,
  max_level: 2,
  score: 5,
  question_ids: multi_questions.map{|q|q.id}
})

test_paper = QuestionBank::TestPaper.create(
  title: "测验",
  score: 100,
  minutes: 120,
  sections_attributes: sections_attributes
)

user.create_user_test_paper(
  test_paper: test_paper
)
