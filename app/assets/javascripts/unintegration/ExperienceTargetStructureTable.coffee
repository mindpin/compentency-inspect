@ExperienceTargetStructureTable = React.createClass
  render: ->
    <div className="experience-target-structure-table">
      <ExperienceTargetStructureTable.Table data={@props.data} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name: '答卷人'
            updated_at: '更新时间'
            status: '状态'
            actions: '操作'
          data_set: @props.data.map (x)=>
            if x.status == "未发布"
              actions =
                <div>
                  <a className="ui button mini blue basic" href={x.edit_url}>
                    <i className='icon write' />
                    编辑
                  </a>
                </div>
            else
              null

            {
              id: x.name
              name: x.name
              status: x.status
              updated_at: x.updated_at
              actions: actions
            }

          th_classes: {}
          td_classes: {
            actions: 'collapsing'
          }
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='经验对象结构' />
        </div>
