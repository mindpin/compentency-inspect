@AdminTestResultShowPage = React.createClass
  render: ->
    <div className="admin-test-paper-results-page">
      <div className="header">
        <div className="tuli">
          <span>图例:</span>
          <span className="correct-true"></span>
          <span>回答正确</span>
          <span className="correct-false"></span>
          <span>回答错误</span>
        </div>
      </div>
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
      {
        if @props.data.test_paper.review_comment != null
          <div className="total-review">
            <div className="review-comment">
              你给出的总评价是：
              <pre>
                {@props.data.test_paper.review_comment}
              </pre>
            </div>
            <button className="ui teal button" onClick={@show_modal}>
              修改总评价
            </button>
          </div>
        else
          <div className="total-review">
            <button className="ui teal button" onClick={@show_modal}>
              增加总评价
            </button>
          </div>
      }
    </div>

  sync_review_comment: (review_comment)->
    @props.data.test_paper.review_comment = review_comment
    @setState {}

  show_modal: ->
    jQuery.open_modal_v2 <AdminTestResultShowPage.TotalReviewForm data={@props.data} target={@} />

  statics:
    Bool: React.createClass
      render: ->
        <div className="bool">
          <div className="content">
            {@props.data.content}
          </div>
          <div className="correct-answer">
          {
            "正确答案是 #{if @props.data.correct_answer then '正确' else '错误'}"
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
              <div className="choice" key={choice.id}>
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
          <div className="content">
            {@props.data.content}
          </div>
          <div className="choices">
          {
            for choice, index in @props.data.choices
              <div className="choice" key={choice.id}>
                {"#{index+1}, #{choice.text}"}
              </div>
          }
          </div>
          <div className="correct-answer">
          {
            "正确答案是 #{correct_answer_indexs.join(',')}"
          }
          </div>
          <div className="user-answer">
          {
            if user_answer_indexs.length == 0
              "他没有回答这道题"
            else
              "他选择的答案是 #{user_answer_indexs.join(',')}"
          }
          </div>
        </div>

    Essay: React.createClass
      render: ->
        <div className="essay">
          <div className="content">
            {@props.data.content}
          </div>
          <div className="user-answer">
            他的回答：
            <pre>
              {@props.data.user_answer}
            </pre>
          </div>
          {
              if @props.data.score == null || @props.data.comment == null
                <div className="review">
                  <button className="ui teal button" onClick={@show_modal}>
                    增加评价
                  </button>
                </div>
              else
                <div className="review">
                  <div className="score">
                    你给出的得分是：{@props.data.score}
                  </div>
                  <div className="comment">
                    你给出的评价是：
                    <pre>
                      {@props.data.comment}
                    </pre>
                  </div>
                  <button className="ui teal button"  onClick={@show_modal} >
                    修改评价
                  </button>
                </div>
            }
        </div>

      sync_score_and_comment: (score, comment)->
        @props.data.score = score
        @props.data.comment = comment
        @setState {}

      show_modal: ->
        jQuery.open_modal_v2 <AdminTestResultShowPage.ReviewForm data={@props.data} target={@} />


    FileUpload: React.createClass
      render: ->
        <div className="file_upload">
          {@props.data.content}
        </div>

    ReviewForm: React.createClass
      render: ->
        {
          SelectField
          TextAreaField
          HiddenField
          Submit
        } = DataForm

        layout =
          label_width: '100px'

        data =
          question_record_id: @props.data.question_record_id
          test_paper_result_id: @props.data.test_paper_result_id
          score: @props.data.score
          comment: @props.data.comment

        <div>
          <h3 className='ui header'>评价</h3>
          <SimpleDataForm
            model='question_record_review'
            post={@props.data.create_question_record_url}
            data={data}
            done={@done}
          >
            <SelectField {...layout} label='得分：' name='score' values={[0..@props.data.max_score]} />
            <TextAreaField  {...layout} label='评语：' name='comment' required />
            <HiddenField  {...layout}  name='question_record_id' />
            <HiddenField  {...layout}  name='test_paper_result_id' />
            <Submit {...layout} text='确定保存' />
          </SimpleDataForm>
        </div>

      done: (data)->
        @props.target.sync_score_and_comment(data.score, data.comment)
        @state.close()

    TotalReviewForm: React.createClass
      render: ->
        {
          TextAreaField
          HiddenField
          Submit
        } = DataForm

        layout =
          label_width: '100px'

        data =
          test_paper_result_id: @props.data.test_paper.test_paper_result_id
          review_comment: @props.data.test_paper.review_comment

        <div>
          <h3 className='ui header'>总评价</h3>
          <SimpleDataForm
            model='test_paper_result_review'
            post={@props.data.test_paper.create_test_paper_result_review_url}
            data={data}
            done={@done}
          >
            <TextAreaField  {...layout} label='评语：' name='review_comment' required />
            <HiddenField  {...layout}  name='test_paper_result_id' />
            <Submit {...layout} text='确定保存' />
          </SimpleDataForm>
        </div>

      done: (data)->
        @props.target.sync_review_comment(data.review_comment)
        @state.close()
