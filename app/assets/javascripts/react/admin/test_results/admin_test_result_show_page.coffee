@AdminTestResultShowPage = React.createClass
  render: ->
    <div className="admin-test-paper-results-page">
      {
        for section in @props.data.test_paper.sections
          <div className="section ui segments" key={section.kind}>
            <div className="desc ui segment">
              {section.kind}
            </div>
            <div className="test-wares ui segments">
              {
                for test_ware in section.test_wares
                  bg_css_name = switch test_ware.kind
                    when "bool", "single_choice", "multi_choice" then "correct-#{test_ware.is_correct}"
                    else ""

                  <div className="test-ware ui segment #{bg_css_name}" key={test_ware.id}>
                    {
                      switch test_ware.kind
                        when "bool" then <AdminTestResultShowPage.Bool data={test_ware} />
                        when "single_choice" then <AdminTestResultShowPage.SingleChoice data={test_ware} />
                        when "multi_choice" then <AdminTestResultShowPage.MultiChoice data={test_ware} />
                        when "essay" then <AdminTestResultShowPage.Essay data={test_ware} />
                        when "file_upload" then <AdminTestResultShowPage.FileUpload data={test_ware} />
                    }
                  </div>
              }
            </div>
          </div>
      }
    </div>
  statics:
    Bool: React.createClass
      render: ->
        <div className="bool">
          <div className="content">
            {@props.data.content}
          </div>
          <div className="correct-answer">
          {
            "正确答案是 #{@props.data.correct_answer ? '正确' : '错误'}"
          }
          </div>
          <div className="user-answer">
          {
            if @props.data.user_answer == null
              "他没有回答这道题"
            else if @props.data.user_answer == true
              "他选择的答案是 正确"
            else if @props.data.user_answer == false
              "他选择的答案是 错误"
          }
          </div>
        </div>

    SingleChoice: React.createClass
      render: ->
        user_answer_index = null
        for choice, index in @props.data.choices
          if @props.data.correct_answer == choice.id
            correct_answer_index = index + 1
          if @props.data.user_answer == choice.id
            user_answer_index = index + 1

        <div className="single_choice">
          <div className="content">
            {@props.data.content}
          </div>
          <div className="choices">
          {
            for choice, index in @props.data.choices
              <div className="choice">
                {"#{index+1}, #{choice.text}"}
              </div>
          }
          </div>
          <div className="correct-answer">
          {
            "正确答案是 #{correct_answer_index}"
          }
          </div>
          <div className="user-answer">
          {
            if user_answer_index == null
              "他没有回答这道题"
            else
              "他选择的答案是 #{user_answer_index}"
          }
          </div>
        </div>

    MultiChoice: React.createClass
      render: ->
        user_answer_indexs    = []
        correct_answer_indexs = []
        for choice, index in @props.data.choices
          if @props.data.correct_answer.indexOf(choice.id) != -1
            correct_answer_indexs.push(index + 1)
          if @props.data.user_answer && @props.data.user_answer.indexOf(choice.id) != -1
            user_answer_indexs.push(index + 1)

        <div className="multi_choice">
          {@props.data.content}
        </div>

    Essay: React.createClass
      render: ->
        <div className="essay">
          {@props.data.content}
        </div>

    FileUpload: React.createClass
      render: ->
        <div className="file_upload">
          {@props.data.content}
        </div>
