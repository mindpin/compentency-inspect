@AdminUserTestPapersPage = React.createClass
  render: ->
    <div className='admin-user-test-papers-page'>
    {
      if @props.data.user_test_papers.length is 0
        data =
          header: '答卷审阅'
          desc: 'xxxxx'
        <ManagerFuncNotReady data={data} />

      else
        <div>
          <AdminUserTestPapersPage.Table data={@props.data} />
        </div>
    }
    </div>

  statics:
    Table: React.createClass
      getInitialState: ->
        user_test_papers: @props.data.user_test_papers
      render: ->
        table_data = {
          fields:
            user_name: '答卷人'
            status: '状态'
            deadline_time: '答卷截至时间'
            actions: '操作'
          data_set: @state.user_test_papers.map (x)=>
            status = switch x.status
              when "NOT_START" then "还没开始，不能阅卷"
              when "RUNNING"   then "正在进行，不能阅卷"
              when "FINISHED"  then "已经结束，可以阅卷"
              when "REVIEW_COMPLETED" then "已经公布成绩"

            if x.deadline_time != 0
              data = new Date(x.deadline_time * 1000).toLocaleString()
            else
              data = ""

            if x.status == "FINISHED"
              actions_create_review_disabled = ""
            else
              actions_create_review_disabled = "disabled"

            if x.has_completed_reviews
              actions_reviews_disabled = ""
            else
              actions_reviews_disabled = "disabled"

            if x.status != "REVIEW_COMPLETED" && x.has_completed_reviews
              actions_review_complete_disabled = ""
            else
              actions_review_complete_disabled = "disabled"


            _click_review_complete = (x)=>
              ()=>
                @click_review_complete(x)

            {
              id: x.id
              user_name: x.current_user.name
              status: status
              deadline_time: data
              actions:
                <div>
                  <a className="ui button mini blue basic #{actions_create_review_disabled}" href={x.admin_show_url}>
                    <i className='icon write' />
                    阅卷
                  </a>
                  <a className="ui button mini blue basic #{actions_reviews_disabled}" href={x.reviews_url}>
                    <i className='icon unhide' />
                    浏览完成的阅卷
                  </a>
                  <a className="ui button mini blue basic #{actions_review_complete_disabled}" href="javascript:;" onClick={_click_review_complete(x)}>
                    <i className='send outline icon' />
                    公布成绩
                  </a>
                </div>
            }

          th_classes: {}
          td_classes: {
            actions: 'collapsing'
          }

          paginate: @props.data.paginate
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='答卷审阅' />
        </div>


      review_complete: (user_test_paper)->
        user_test_papers = @state.user_test_papers
        for utp, i in user_test_papers
          if utp.id == user_test_paper.id
            user_test_papers[i] = user_test_paper
            break

        @setState
          user_test_papers: user_test_papers


      click_review_complete: (user_test_paper)->
        jQuery.modal_confirm
          text: """
            <div>
              <div>确定公布成绩吗？</div>
            </div>
          """
          yes: =>
            jQuery.ajax
              url: user_test_paper.review_complete_url
              type: 'PUT'
            .done (res)=>
              @review_complete res
