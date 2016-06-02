@AdminTestResultShowPage = React.createClass
  render: ->
    <div className="admin-test-paper-results-page">
      <AdminTestResultShowPage.Header />
      <AdminTestResultShowPage.TestPaper data={@props.data} page={@} />
      <AdminTestResultShowPage.TotalReview data={@props.data} page={@} />
      <AdminTestResultShowPage.ReviewCompleteSubmit ref='complete_submit' data={@props.data} page={@} />
    </div>

  statics:
    Header: React.createClass
      render: ->
        <div className="header">
          <div className="tuli">
            <span>图例:</span>
            <span className="correct-true"></span>
            <span>回答正确</span>
            <span className="correct-false"></span>
            <span>回答错误</span>
          </div>
        </div>

    TestPaper: React.createClass
      render: ->
        <div className="test-paper ui segment">
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
                          review: @props.data.review

                    <div className="test-ware ui segment #{bg_css_name}" key={test_ware.id}>
                      {
                        switch test_ware.kind
                          when "bool" then <AdminTestResultShowPage.Bool data={data} />
                          when "single_choice" then <AdminTestResultShowPage.SingleChoice data={data} />
                          when "multi_choice" then <AdminTestResultShowPage.MultiChoice data={data} />
                          when "essay" then <AdminTestResultShowPage.Essay data={data} page={@props.page} />
                          when "file_upload" then <AdminTestResultShowPage.FileUpload data={data} page={@props.page} />
                      }
                    </div>
                }
              </div>
            </div>
        }
        </div>

    TotalReview: React.createClass
      render: ->
        if @props.data.review.comment != null
          <div className="total-review">
            <div className="review-comment">
              审阅总评价是：
              <pre>
                {@props.data.review.comment}
              </pre>
            </div>
            {
              if @props.data.review.status != "completed"
                <button className="ui teal button" onClick={@show_modal}>
                  修改总评价
                </button>
            }
          </div>
        else
          if @props.data.review.status != "completed"
            <div className="total-review">
              <button className="ui teal button" onClick={@show_modal}>
                增加总评价
              </button>
            </div>

      sync_review_comment: (comment)->
        @props.data.review.comment = comment
        @setState {}
        @props.page.setState {}

      show_modal: ->
        @open_modal = jQuery.open_modal <AdminTestResultShowPage.TotalReviewForm data={@props.data} target={@} />

      close_modal: ->
        @open_modal.close()

    ReviewCompleteSubmit: React.createClass
      render: ->
        if @is_completed()
          <div className="review-complete-submit">
            审阅已经完成
          </div>
        else if @valid()
          <div className="review-complete-submit">
            <button className="ui teal button" onClick={@show_modal}>
              确定完成审阅
            </button>
          </div>
        else
          <div className="review-complete-submit">
            <button className="ui teal button disabled">
              确定完成审阅
            </button>
          </div>

      valid: ->
        console.log "valid"
        valid = true
        valid = false if @props.data.review.comment == null
        for r in @props.data.review.test_ware_reviews
          valid = false if r.score == null || r.comment == null
          break if valid == false
        valid

      is_completed: ->
        @props.data.review.status == "completed"

      show_modal: ->
        jQuery.modal_confirm
          text: """
            <div>
              <div>确定完成审阅吗？</div>
            </div>
          """
          yes: =>
            jQuery.ajax
              url: @props.data.set_review_complete_url
              data:
                test_paper_result_id: @props.data.id
              type: 'POST'
            .done (res)=>
              @props.data.review.status = res.status
              @setState {}
              @props.page.setState {}

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
              "答题者没有回答这道题"
            else if @props.data.test_ware.user_answer == true
              "答题者选择的答案是 正确"
            else if @props.data.test_ware.user_answer == false
              "答题者选择的答案是 错误"
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
              "答题者没有回答这道题"
            else
              "答题者选择的答案是 #{user_answer_index}"
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
              "答题者没有回答这道题"
            else
              "答题者选择的答案是 #{user_answer_indexs.join(',')}"
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
            答题者的回答：
            <pre>
              {@props.data.test_ware.user_answer}
            </pre>
          </div>
          {
              if @props.data.test_ware_review.score == null || @props.data.test_ware_review.comment == null
                if @props.data.review.status != "completed"
                  <div className="review">
                    <button className="ui teal button" onClick={@show_modal}>
                      增加评价
                    </button>
                  </div>
              else
                <div className="review">
                  <div className="score">
                    审阅得分是：{@props.data.test_ware_review.score}
                  </div>
                  <div className="comment">
                    审阅评价是：
                    <pre>
                      {@props.data.test_ware_review.comment}
                    </pre>
                  </div>
                  {
                    if @props.data.review.status != "completed"
                      <button className="ui teal button"  onClick={@show_modal} >
                        修改评价
                      </button>
                  }
                </div>
            }
        </div>

      sync_score_and_comment: (score, comment)->
        @props.data.test_ware_review.score = score
        @props.data.test_ware_review.comment = comment
        @setState {}
        @props.page.setState {}

      show_modal: ->
        @open_modal = jQuery.open_modal <AdminTestResultShowPage.ReviewForm data={@props.data} target={@} />

      close_modal: ->
        @open_modal.close()

    FileUpload: React.createClass
      render: ->
        <div className="file_upload">
          <div className="content">
            {@props.data.test_ware.content}
          </div>
          <div className="user-answer">
            <a href={@props.data.test_ware.user_answer}>
              下载答题者提交的文件
            </a>
          </div>
          {
              if @props.data.test_ware_review.score == null || @props.data.test_ware_review.comment == null
                if @props.data.review.status != "completed"
                  <div className="review">
                    <button className="ui teal button" onClick={@show_modal}>
                      增加评价
                    </button>
                  </div>
              else
                <div className="review">
                  <div className="score">
                    审阅得分是：{@props.data.test_ware_review.score}
                  </div>
                  <div className="comment">
                    审阅评价是：
                    <pre>
                      {@props.data.test_ware_review.comment}
                    </pre>
                  </div>
                  {
                    if @props.data.review.status != "completed"
                      <button className="ui teal button"  onClick={@show_modal} >
                        修改评价
                      </button>
                  }
                </div>
            }
        </div>

      sync_score_and_comment: (score, comment)->
        @props.data.test_ware_review.score = score
        @props.data.test_ware_review.comment = comment
        @setState {}
        @props.page.setState {}

      show_modal: ->
        @open_modal = jQuery.open_modal <AdminTestResultShowPage.ReviewForm data={@props.data} target={@} />

      close_modal: ->
        @open_modal.close()

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
        @props.target.close_modal()

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
        @props.target.close_modal()
