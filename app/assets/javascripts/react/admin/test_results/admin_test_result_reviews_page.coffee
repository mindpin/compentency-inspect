@AdminTestResultReviewsPage = React.createClass
  render: ->
    data =
      id:         @props.data.id
      user:       @props.data.user
      status:     @props.data.status
      test_paper: @props.data.test_paper
      review_result:  @props.data.review_result

    <div className="admin-test-result-reviews-page">
      <div className="header">
        <div>
          <div>简答题和画图题的得分规则如下：</div>
          <div>
            多个阅卷人对每个简答题和画图题进行主观评分，评分范围是 0 ~ 每题的满分值
          </div>
          <div>
            然后取所有阅卷人评分的平均值作为该题的最终得分
          </div>
        </div>
        <div>
          {"满分：#{@props.data.review_result.score_data.max_score}"}
        </div>
        <div>
          {"得分：#{@props.data.review_result.score_data.total_score}"}
        </div>
      </div>
      <AdminTestResultReviewsPage.TestPaper data={data} />
      <AdminTestResultReviewsPage.TotalReviewTabs data={data} />
    </div>

  statics:
    ToggleTabs: React.createClass
      componentDidMount: ->
        @show(0)

      show: (index)->
        $that =  ReactDOM.findDOMNode(@)
        jQuery($that).find(".tabs .tab").removeClass("active")
        jQuery($that).find(".tabs .tab:nth-of-type(#{index+1})").addClass("active")

        jQuery($that).find(".contents .content").hide()
        jQuery($that).find(".contents .content:nth-of-type(#{index+1})").show()

      render: ->
        <div className="taggle-tabs">
          <div className="ui top attached tabular menu tabs">
          {
            for item, i in @props.data
              _click = (_i)=>
                ()=>
                  @show(_i)
              <a className='item tab' key={i} onClick={_click(i)}>{item.tab}</a>
          }
          </div>
          <div className="ui bottom attached segment contents">
          {
            for item, i in @props.data
              <div className="content" key={i}>{item.content}</div>
          }
          </div>
        </div>

    TotalReviewTabs: React.createClass
      render: ->
        <AdminTestResultReviewsPage.ToggleTabs data={@get_total_reviews_data()} />

      get_total_reviews_data: ->
        total_reviews_data = []
        for item in @props.data.review_result.reviews
          tab = item.user.name
          content = <AdminTestResultReviewsPage.TotalReviewTabs.TotalReview data={item.review.comment} />
          total_reviews_data.push(
            tab: tab,
            content: content
          )
        total_reviews_data

      statics:
        TotalReview: React.createClass
          render: ->
            <div className="total-review">
              <div className="review-comment">
                审阅总评价是：
                <pre>
                  {@props.data}
                </pre>
              </div>
            </div>

    TestPaper: React.createClass
      render: ->
        <div className="test-paper">
        {
          for section, i in @props.data.test_paper.sections
            data =
              id:            @props.data.id
              section:       section
              review_result: @props.data.review_result
              get_reviews_data: @get_reviews_data
              get_review_score: @get_review_score

            <AdminTestResultReviewsPage.TestPaper.Section data={data} key={i}/>
        }
        </div>

      get_reviews_data: (test_ware_id)->
        reviews_data = []
        for item in @props.data.review_result.reviews
          tab = item.user.name
          test_ware_review = null
          for r in item.review.test_ware_reviews
            if r.question_id == test_ware_id
              test_ware_review = r
              break
          content = <AdminTestResultReviewsPage.TestPaper.Section.TestWareReview data={test_ware_review} />
          reviews_data.push(
            tab: tab,
            content: content
          )
        reviews_data

      get_review_score: (test_ware_id)->
        for s in @props.data.review_result.score_data.sections
          for q in s.questions
            if q.id == test_ware_id
              return {score: q.score}

      statics:
        Section: React.createClass
          getInitialState: ->
            section_style: "close"

          get_per_test_ware_max_score: ->
            for s in @props.data.review_result.score_data.sections
              if s.id == @props.data.section.id
                return s.per_question_max_score

          get_section_total_score: ->
            for s in @props.data.review_result.score_data.sections
              if s.id == @props.data.section.id
                return s.section_total_score

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
                <span>{"（每题#{@get_per_test_ware_max_score()}分，得分 #{@get_section_total_score()}）"}</span>
              </div>
              <div className="section-content">
                {
                  for test_ware in @props.data.section.test_wares
                    switch test_ware.kind
                      when "bool", "single_choice", "multi_choice"
                        data =
                          test_ware: test_ware
                      else
                        data =
                          test_ware:     test_ware
                          get_reviews_data: @props.data.get_reviews_data
                          get_review_score: @props.data.get_review_score

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
                            <AdminTestResultReviewsPage.TestPaper.Section.Essay data={data} />
                          when "file_upload"
                            <AdminTestResultReviewsPage.TestPaper.Section.FileUpload data={data} />
                      }
                    </div>
                }
              </div>
            </div>

          statics:
            Essay: React.createClass
              render: ->
                <div className="essay">
                  <QuestionContent data={@props.data.test_ware} />
                  <AdminTestResultShowPage.Essay.UserAnswer data={user_answer: @props.data.test_ware.user_answer} />
                  <AdminTestResultReviewsPage.TestPaper.Section.TestWareScore data={@props.data.get_review_score(@props.data.test_ware.id)} />
                  <AdminTestResultReviewsPage.ToggleTabs data={@props.data.get_reviews_data(@props.data.test_ware.id)} />
                </div>

            FileUpload: React.createClass
              render: ->
                <div className="file_upload">
                  <QuestionContent data={@props.data.test_ware} />
                  <AdminTestResultShowPage.FileUpload.UserAnswer data={user_answer: @props.data.test_ware.user_answer} />
                  <AdminTestResultReviewsPage.TestPaper.Section.TestWareScore data={@props.data.get_review_score(@props.data.test_ware.id)} />
                  <AdminTestResultReviewsPage.ToggleTabs data={@props.data.get_reviews_data(@props.data.test_ware.id)} />
                </div>

            TestWareReview: React.createClass
              render: ->
                <div className="review">
                  <div className="score">
                    审阅得分是：{@props.data.score}
                  </div>
                  <div className="comment">
                    审阅评价是：
                    <pre>
                      {@props.data.comment}
                    </pre>
                  </div>
                </div>

            TestWareScore: React.createClass
              render: ->
                <div className="test-paper-score">
                  {"得分：#{@props.data.score}"}
                </div>
