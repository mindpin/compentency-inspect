@AdminTestResultReviewsPage = React.createClass
  componentDidMount: ->
    @show(0)

  show: (index)->
    $that =  ReactDOM.findDOMNode(@)
    jQuery($that).find(".reviewer-names .reviewer-name").removeClass("active")
    jQuery($that).find(".reviewer-names .reviewer-name:nth-of-type(#{index+1})").addClass("active")

    jQuery($that).find(".reviewer-reviews .reviewer-review").hide()
    jQuery($that).find(".reviewer-reviews .reviewer-review:nth-of-type(#{index+1})").show()

  render: ->
    <div className="admin-test-result-reviews-page">
      <div className="ui pointing menu reviewer-names">
      {
        for review, i in @props.data
          _click = (_i)=>
            ()=>
              @show(_i)
          <a className='item reviewer-name' key={review.id} onClick={_click(i)}>
            {review.user.name}
          </a>
      }
      </div>
      <div className="ui segments reviewer-reviews">
      {
        for review, i in @props.data
          tpr = review.test_paper_result
          data =
            id:         tpr.id
            user:       tpr.user
            status:     tpr.status
            test_paper: tpr.test_paper
            review_status:     tpr.review.status
            review_comment:    tpr.review.comment
            test_ware_reviews: tpr.review.test_ware_reviews

          <div className="ui segment reviewer-review"  key={review.id} >
            <div className="ui segment">
              总得分：{review.total_score}
            </div>
            <AdminTestResultShowPage.TestPaper data={data} />
            <AdminTestResultShowPage.TotalReview data={data} />
          </div>
      }
      </div>
    </div>
