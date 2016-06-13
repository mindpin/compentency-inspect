@AdminQuestionPointsPage = React.createClass
  render: ->
    <div className='admin-question-points-page'>
      <div>
        <a className='ui button green' href={@props.data.new_question_point_url}>创建知识点</a>
      </div>
      <AdminQuestionPointsPage.Table data={@props.data} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name: '知识点'
            actions: '操作'
          data_set: @props.data.question_points.map (x)->
            {
              id: x.id
              name: x.name
              actions:
                <a className='ui button mini green' href={x.admin_edit_url}>
                  <i className='ui edit' /> 修改
                </a>
            }

          th_classes: {}
          td_classes: {
          }

          paginate: @props.data.paginate
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='知识点' />
        </div>

