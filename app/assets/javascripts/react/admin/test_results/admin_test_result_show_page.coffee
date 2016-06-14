@AdminTestResultShowPage = React.createClass
  getInitialState: ->
    review_status:     @props.data.review.status
    review_comment:    @props.data.review.comment
    test_ware_reviews: @props.data.review.test_ware_reviews

  render: ->
    data =
      id:         @props.data.id
      user:       @props.data.user
      status:     @props.data.status
      test_paper: @props.data.test_paper
      create_question_review_url: @props.data.create_question_review_url
      create_review_url:          @props.data.create_review_url
      set_review_complete_url:    @props.data.set_review_complete_url
      review_status:     @state.review_status
      review_comment:    @state.review_comment
      test_ware_reviews: @state.test_ware_reviews
      change_review_status: @change_review_status
      change_review_comment: @change_review_comment
      change_test_ware_review: @change_test_ware_review

    <div className="admin-test-paper-results-page">
      <AdminTestResultShowPage.TestPaper data={data} />
      <AdminTestResultShowPage.TotalReview data={data} />
      <AdminTestResultShowPage.ReviewCompleteSubmit data={data} />
    </div>

  change_review_status: (status)->
    @setState
      review_status: status

  change_review_comment: (comment)->
    @setState
      review_comment: comment

  change_test_ware_review: (question_id, score, comment)->
    test_ware_reviews = @state.test_ware_reviews

    for review, i in test_ware_reviews
      if review.question_id == question_id
        test_ware_reviews[i] =
          question_id: question_id
          score: score
          comment: comment

    @setState
      test_ware_reviews: test_ware_reviews

  statics:
    TestPaper: React.createClass
      render: ->
        <div className="test-paper">
        {
          for section, i in @props.data.test_paper.sections
            data =
              id:                @props.data.id
              section:           section
              test_ware_reviews: @props.data.test_ware_reviews
              review_status:     @props.data.review_status
              create_question_review_url: @props.data.create_question_review_url
              change_test_ware_review:    @props.data.change_test_ware_review

            <AdminTestResultShowPage.TestPaper.Section data={data} key={i}/>
        }
        </div>

      statics:
        Section: React.createClass
          getInitialState: ->
            section_style: "close"

          render: ->
            kind_str = switch @props.data.section.kind
              when "bool"          then "判断题"
              when "single_choice" then "单选题"
              when "multi_choice"  then "多选题"
              when "essay"         then "简答题"
              when "file_upload"   then "画图题"

            content_taggle_open_close = (evt)=>
              $div = jQuery(ReactDOM.findDOMNode(@)).closest(".section")
              $div.toggleClass("close")
              $div.toggleClass("open")

            <div className="section #{@state.section_style}" key={@props.data.section.kind} >
              <div className="section-desc" onClick={content_taggle_open_close}>
                <i className="angle right icon"></i>
                <i className="angle down icon"></i>
                <span>{kind_str}</span>
              </div>
              <div className="section-content">
                {
                  for test_ware in @props.data.section.test_wares
                    switch test_ware.kind
                      when "bool", "single_choice", "multi_choice"
                        data =
                          test_ware: test_ware
                      else
                        current_review = null
                        for r in @props.data.test_ware_reviews
                          if r.question_id == test_ware.id
                            current_review = r
                            break

                        data =
                          test_ware:            test_ware
                          test_ware_review:     current_review
                          review_status:        @props.data.review_status
                          test_paper_result_id: @props.data.id
                          create_question_review_url: @props.data.create_question_review_url
                          change_test_ware_review:    @props.data.change_test_ware_review

                    <div className="test-ware" key={test_ware.id}>
                      {
                        switch test_ware.kind
                          when "bool"
                            <AdminTestResultShowPage.Bool data={data} />
                          when "single_choice"
                            <AdminTestResultShowPage.SingleChoice data={data} />
                          when "multi_choice"
                            <AdminTestResultShowPage.MultiChoice data={data} />
                          when "essay"
                            <AdminTestResultShowPage.Essay data={data} />
                          when "file_upload"
                            <AdminTestResultShowPage.FileUpload data={data} />
                      }
                    </div>
                }
              </div>
            </div>

    Bool: React.createClass
      render: ->
        if @props.data.test_ware.user_answer == null
          user_answer = "未填写"
        else if @props.data.test_ware.user_answer == true
          user_answer = "正确"
        else if @props.data.test_ware.user_answer == false
          user_answer = "错误"

        correct_answer = if @props.data.test_ware.correct_answer then '正确' else '错误'

        subjective_question_answer_data =
          user_answer:    user_answer
          correct_answer: correct_answer
          is_correct:     @props.data.test_ware.is_correct

        <div className="bool">
          <div className="content">
            <QuestionContent data={@props.data.test_ware} />
          </div>
          <AdminTestResultShowPage.SubjectiveQuestionAnswer data={subjective_question_answer_data} />
        </div>

    SingleChoice: React.createClass
      render: ->
        user_answer = "未填写"
        for choice, index in @props.data.test_ware.choices
          if @props.data.test_ware.correct_answer == choice.id
            correct_answer = index + 1
          if @props.data.test_ware.user_answer == choice.id
            user_answer = index + 1

        subjective_question_answer_data =
          user_answer:    user_answer
          correct_answer: correct_answer
          is_correct:     @props.data.test_ware.is_correct

        <div className="single_choice">
          <div className="content">
            <QuestionContent data={@props.data.test_ware} />
          </div>
          <div className="choices">
          {
            for choice, index in @props.data.test_ware.choices
              <div className="choice" key={choice.id}>
                {"#{index+1}, #{choice.text}"}
              </div>
          }
          </div>
          <AdminTestResultShowPage.SubjectiveQuestionAnswer data={subjective_question_answer_data} />
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

        correct_answer = correct_answer_indexs.join(',')
        if user_answer_indexs.length == 0
          user_answer = "未填写"
        else
          user_answer = user_answer_indexs.join(',')

        subjective_question_answer_data =
          user_answer:    user_answer
          correct_answer: correct_answer
          is_correct:     @props.data.test_ware.is_correct

        <div className="multi_choice">
          <div className="content">
            <QuestionContent data={@props.data.test_ware} />
          </div>
          <div className="choices">
          {
            for choice, index in @props.data.test_ware.choices
              <div className="choice" key={choice.id}>
                {"#{index+1}, #{choice.text}"}
              </div>
          }
          </div>
          <AdminTestResultShowPage.SubjectiveQuestionAnswer data={subjective_question_answer_data} />
        </div>

    Essay: React.createClass
      render: ->
        <div className="essay">
          <QuestionContent data={@props.data.test_ware} />
          <AdminTestResultShowPage.Essay.UserAnswer data={user_answer: @props.data.test_ware.user_answer} />
          <AdminTestResultShowPage.TestWareReview data={@props.data} />
        </div>

      statics:
        UserAnswer: React.createClass
          render: ->
            <div className="user-answer">
              <span>填写的答案：</span>
              {
                if @props.data.user_answer == null || @props.data.user_answer == ""
                  <span>未填写</span>
                else
                  <div>
                    <pre>
                      {@props.data.user_answer}
                    </pre>
                  </div>
              }
            </div>

    FileUpload: React.createClass
      render: ->
        <div className="file_upload">
          <QuestionContent data={@props.data.test_ware} />
          <AdminTestResultShowPage.FileUpload.UserAnswer data={user_answer: @props.data.test_ware.user_answer} />
          <AdminTestResultShowPage.TestWareReview data={@props.data} />
        </div>

      statics:
        UserAnswer: React.createClass
          render: ->
            <div className="user-answer">
              <span>提交的文件：</span>
              {
                if @props.data.user_answer == null
                  <span>未提交</span>
                else
                  <a href={@props.data.user_answer}>
                    下载提交的文件
                  </a>
              }
            </div>

    SubjectiveQuestionAnswer: React.createClass
      render: ->
        if @props.data.is_correct
          user_answer_icon_style = "icon checkmark green"
        else
          user_answer_icon_style = "icon remove red"

        <div>
          <div className="user-answer">
            {"填写的答案：#{@props.data.user_answer}"}
            <i className={user_answer_icon_style}></i>
          </div>
          <div className="correct-answer">{"正确的答案：#{@props.data.correct_answer}"}</div>
        </div>

    TotalReview: React.createClass
      render: ->
        if @props.data.review_comment != null
          <div className="total-review">
            <div className="review-comment">
              审阅总评价是：
              <pre>
                {@props.data.review_comment}
              </pre>
            </div>
            {
              if @props.data.review_status != "completed"
                <button className="ui teal button" onClick={@show_modal}>
                  修改总评价
                </button>
            }
          </div>
        else
          if @props.data.review_status != "completed"
            <div className="total-review">
              <button className="ui teal button" onClick={@show_modal}>
                增加总评价
              </button>
            </div>

      show_modal: ->
        data =
          id:                @props.data.id
          review_comment:    @props.data.review_comment
          create_review_url: @props.data.create_review_url
          close_modal:       @close_modal
          change_review_comment: @props.data.change_review_comment

        @open_modal = jQuery.open_modal <AdminTestResultShowPage.TotalReview.TotalReviewForm data={data} />

      close_modal: ->
        @open_modal.close()

      statics:
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
              comment: @props.data.review_comment

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
            @props.data.change_review_comment(data.comment)
            @props.data.close_modal()

    TestWareReview: React.createClass
      render: ->
        if @props.data.test_ware_review.score == null || @props.data.test_ware_review.comment == null
          if @props.data.review_status != "completed"
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
              if @props.data.review_status != "completed"
                <button className="ui teal button"  onClick={@show_modal} >
                  修改评价
                </button>
            }
          </div>

      show_modal: ->
        data =
          test_ware: @props.data.test_ware
          test_ware_review: @props.data.test_ware_review
          test_paper_result_id: @props.data.test_paper_result_id
          change_test_ware_review: @props.data.change_test_ware_review
          create_question_review_url: @props.data.create_question_review_url
          close_modal: @close_modal

        @open_modal = jQuery.open_modal <AdminTestResultShowPage.TestWareReview.ReviewForm data={data} />

      close_modal: ->
        @open_modal.close()

      statics:
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
            @props.data.change_test_ware_review(@props.data.test_ware.id, data.score, data.comment)
            @props.data.close_modal()

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
        valid = true
        valid = false if @props.data.review_comment == null
        for r in @props.data.test_ware_reviews
          valid = false if r.score == null || r.comment == null
          break if valid == false
        valid

      is_completed: ->
        @props.data.review_status == "completed"

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
              @props.data.change_review_status(res.status)
