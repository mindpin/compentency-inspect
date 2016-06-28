@AdminTestResultCompletedIndexPage = React.createClass
  render: ->
    <div className="admin_test_result_completed_index_page">
      <AdminTestResultCompletedIndexPage.Table data={@props.data} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name: '答卷人'
            total_score: '总得分（满分100）'
            single_choice_score: '单选题得分'
            multi_choice_score: '多选题得分'
            essay_score: '论述题'
            file_upload_score: '画图题'
            actions: '操作'
          data_set: @props.data.results.map (result)=>
            find_score_by_kind = (kind)=>
              for s in result.sections
                if s.kind == kind
                  return s.section_total_score

            {
              id: result.id,
              name: result.user.name,
              total_score: result.total_score,
              single_choice_score: find_score_by_kind("single_choice"),
              multi_choice_score: find_score_by_kind("multi_choice"),
              essay_score: find_score_by_kind("essay"),
              file_upload_score: find_score_by_kind("file_upload"),
              actions:
                <div>
                  <a className="ui button mini blue basic" href={result.desc_url} target="_blank" >
                    <i className='send outline icon' />
                    查看详情
                  </a>
                </div>
            }
          th_classes: {
          }
          td_classes: {
          }
          paginate: @props.data.paginate
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='公布成绩汇总页' />
        </div>
