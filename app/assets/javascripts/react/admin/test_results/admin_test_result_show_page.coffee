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
                  switch test_ware.kind
                    when "bool", "single_choice", "multi_choice"
                      bg_css_name = "correct-#{test_ware.is_correct}"
                      data =
                        test_ware: test_ware
                    else
                      console.log @props.data
                      current_review = null
                      for r in @props.data.review.test_ware_reviews
                        if r.question_id == test_ware.id
                          current_review = r
                          break

                      bg_css_name = ""
                      data =
                        test_ware: test_ware
                        test_paper_result_id: @props.data.id
                        create_question_review_url: @props.data.create_question_review_url
                        test_ware_review: current_review

                  <div className="test-ware ui segment #{bg_css_name}" key={test_ware.id}>
                    {
                      switch test_ware.kind
                        when "bool" then <AdminTestResultShowPage.Bool data={data} />
                        when "single_choice" then <AdminTestResultShowPage.SingleChoice data={data} />
                        when "multi_choice" then <AdminTestResultShowPage.MultiChoice data={data} />
                        when "essay" then <AdminTestResultShowPage.Essay data={data} />
                        when "file_upload" then <AdminTestResultShowPage.FileUpload data={data} />
                    }
                  </div>
              }
            </div>
          </div>
      }
      {
        if @props.data.review.comment != null
          <div className="total-review">
            <div className="review-comment">
              你给出的总评价是：
              <pre>
                {@props.data.review.comment}
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

  sync_review_comment: (comment)->
    @props.data.review.comment = comment
    @setState {}

  show_modal: ->
    jQuery.open_modal_v2 <AdminTestResultShowPage.TotalReviewForm data={@props.data} target={@} />

  statics:
    Bool: React.createClass
      render: ->
        <div className="bool">
          <div className="content">
            {@props.data.test_ware.content}
          </div>
          <div className="correct-answer">
          {
            "正确答案是 #{if @props.data.test_ware.correct_answer then '正确' else '错误'}"
          }
          </div>
          <div className="user-answer">
          {
            if @props.data.test_ware.user_answer == null
              "他没有回答这道题"
            else if @props.data.test_ware.user_answer == true
              "他选择的答案是 正确"
            else if @props.data.test_ware.user_answer == false
              "他选择的答案是 错误"
          }
          </div>
        </div>

    SingleChoice: React.createClass
      render: ->
        user_answer_index = null
        for choice, index in @props.data.test_ware.choices
          if @props.data.test_ware.correct_answer == choice.id
            correct_answer_index = index + 1
          if @props.data.test_ware.user_answer == choice.id
            user_answer_index = index + 1

        <div className="single_choice">
          <div className="content">
            {@props.data.test_ware.content}
          </div>
          <div className="choices">
          {
            for choice, index in @props.data.test_ware.choices
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
        for choice, index in @props.data.test_ware.choices
          if @props.data.test_ware.correct_answer.indexOf(choice.id) != -1
            correct_answer_indexs.push(index + 1)
          if @props.data.test_ware.user_answer && @props.data.test_ware.user_answer.indexOf(choice.id) != -1
            user_answer_indexs.push(index + 1)

        <div className="multi_choice">
          <div className="content">
            {@props.data.test_ware.content}
          </div>
          <div className="choices">
          {
            for choice, index in @props.data.test_ware.choices
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
            {@props.data.test_ware.content}
          </div>
          <div className="user-answer">
            他的回答：
            <pre>
              {@props.data.test_ware.user_answer}
            </pre>
          </div>
          {
              if @props.data.test_ware_review.score == null || @props.data.test_ware_review.comment == null
                <div className="review">
                  <button className="ui teal button" onClick={@show_modal}>
                    增加评价
                  </button>
                </div>
              else
                <div className="review">
                  <div className="score">
                    你给出的得分是：{@props.data.test_ware_review.score}
                  </div>
                  <div className="comment">
                    你给出的评价是：
                    <pre>
                      {@props.data.test_ware_review.comment}
                    </pre>
                  </div>
                  <button className="ui teal button"  onClick={@show_modal} >
                    修改评价
                  </button>
                </div>
            }
        </div>

      sync_score_and_comment: (score, comment)->
        @props.data.test_ware_review.score = score
        @props.data.test_ware_review.comment = comment
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
          question_id: @props.data.test_ware.id
          test_paper_result_id: @props.data.test_paper_result_id
          score: @props.data.test_ware_review.score
          comment: @props.data.test_ware_review.comment

        <div>
          <h3 className='ui header'>评价</h3>
          <SimpleDataForm
            model='test_paper_result_question_review'
            post={@props.data.create_question_review_url}
            data={data}
            done={@done}
          >
            <SelectField {...layout} label='得分：' name='score' values={[0..@props.data.test_ware.max_score]} />
            <TextAreaField  {...layout} label='评语：' name='comment' required />
            <HiddenField  {...layout}  name='question_id' />
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
          test_paper_result_id: @props.data.id
          comment: @props.data.review.comment

        <div>
          <h3 className='ui header'>总评价</h3>
          <SimpleDataForm
            model='test_paper_result_review'
            post={@props.data.create_review_url}
            data={data}
            done={@done}
          >
            <TextAreaField  {...layout} label='评语：' name='comment' required />
            <HiddenField  {...layout}  name='test_paper_result_id' />
            <Submit {...layout} text='确定保存' />
          </SimpleDataForm>
        </div>

      done: (data)->
        @props.target.sync_review_comment(data.comment)
        @state.close()
